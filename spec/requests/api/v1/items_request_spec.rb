require 'rails_helper'

RSpec.describe 'Items API' do
  describe '/items' do
    it 'sends a list of merchants' do
      create_list(:item, 4)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items).to be_a(Hash)
      expect(items).to have_key(:data)

      items_info = items[:data]
      items_info.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    it 'by default sends 20 merchants per page and defaults to page 1' do
      create_list(:item, 25)

      get '/api/v1/items'

      expect(response).to be_successful

      page_default = JSON.parse(response.body, symbolize_names: true)

      expect(page_default[:data].count).to eq(20)

      get '/api/v1/items?page=1'

      page_1 = JSON.parse(response.body, symbolize_names: true)

      expect(page_1[:data]).to eq(page_default[:data])

      get '/api/v1/items?page=2'

      page_2 = JSON.parse(response.body, symbolize_names: true)

      expect(page_2[:data].count).to eq(5)
      expect(page_2[:data]).to_not eq(page_1[:data])
    end

    it 'allows user to specify per page' do
      create_list(:item, 55)

      get '/api/v1/items?per_page=50'

      page_1 = JSON.parse(response.body, symbolize_names: true)

      expect(page_1[:data].count).to eq(50)
    end

    it 'returns no data for empty pages' do
      create_list(:item, 20)
      get '/api/v1/items?page=2'

      page_2 = JSON.parse(response.body, symbolize_names: true)

      expect(page_2[:data].empty?).to eq(true)
    end
  end

  describe '/items/:id' do
    it 'retrieves a single item record' do
      item_1 = create(:item)

      get "/api/v1/items/#{item_1.id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to have_key(:data)
      expect(item[:data]).to be_a(Hash)

      item_attr = item[:data]
      expect(item_attr).to have_key(:attributes)
      expect(item_attr[:attributes]).to be_a(Hash)

      expect(item_attr[:attributes]).to have_key(:name)
      expect(item_attr[:attributes][:name]).to be_a(String)

      expect(item_attr[:attributes]).to have_key(:description)
      expect(item_attr[:attributes][:description]).to be_a(String)

      expect(item_attr[:attributes]).to have_key(:unit_price)
      expect(item_attr[:attributes][:unit_price]).to be_a(Float)

      expect(item_attr[:attributes]).to have_key(:merchant_id)
      expect(item_attr[:attributes][:merchant_id]).to be_a(Integer)
    end

    it 'returns a 400 error when no merchant found' do
      get '/api/v1/items/999999'
      expect(response.status).to eq(404)
    end

    it 'deletes an item by id' do
      create_list(:item, 3)
      item = create(:item)
      expect(Item.all.count).to eq(4)
      delete "/api/v1/items/#{item.id}"
      expect(Item.all.count).to eq(3)

      expect(response.status).to eq(204)
    end

    it 'sends 404 if item not found' do
      create_list(:item, 3)
      expect(Item.all.count).to eq(3)

      delete '/api/v1/items/99999'
      expect(Item.all.count).to eq(3)

      expect(response.status).to eq(404)
    end

    it 'deletes invoice if only item on invoice' do
      item_1 = create(:item)
      item_2 = create(:item)
      invoice_1 = create(:invoice)
      invoice_2 = create(:invoice)
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)
      invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2)

      expect(Item.all.count).to eq(2)
      expect(Invoice.all.count).to eq(2)
      expect(InvoiceItem.all.count).to eq(3)

      delete "/api/v1/items/#{item_1.id}"

      expect(Item.all.count).to eq(1)
      expect(Invoice.all.count).to eq(1)
      expect(InvoiceItem.all.count).to eq(1)
    end
  end

  describe 'post to /api/v1/items' do
    it 'can create a new item' do
      merchant = create(:merchant)
      item_params = {
        "name": "cat socks",
        "description": "tiny socks for cat feet",
        "unit_price": 10.99,
        "merchant_id": merchant.id
        }
      header = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: {item: item_params}

      expect(response).to be_successful
      created_item = Item.last

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(merchant.id)
    end

    it 'will not create item without attributes' do
      merchant = create(:merchant)
      item_params = {name: "A thing",
                     merchant_id: merchant.id
                    }
      header = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: {item: item_params}

      expect(response.status).to eq(400)
    end

    it 'will not create item with incorrect attribute data types' do
      merchant = create(:merchant)
      item_params = {name: 7545324,
                     description: 87675,
                     unit_price: "forty-five dollars",
                     merchant_id: merchant.id
                    }
      header = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: {item: item_params}

      expect(response.status).to eq(400)
    end
  end

  describe 'patch to /api/v1/items/:id' do
    it 'can update and existing item' do
      item = create(:item)
      previous_name = item.name
      item_params = {name: 'Squishy cat'}
      header = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: {item: item_params}
      expect(response).to be_successful

      updated_item = Item.find(item.id)

      expect(updated_item.name).to eq('Squishy cat')
      expect(updated_item.name).to_not eq(previous_name)
    end

    it 'will not update with incorrect data types' do
      item = create(:item)
      og_unit_price = item.unit_price
      item_params = {unit_price: "a lot of money"}
      header = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: {item: item_params}
      expect(response.status).to eq(400)

      updated_item = Item.find(item.id)

      expect(updated_item.unit_price).to eq(og_unit_price)
    end

    it 'will not update with nonexistant merchant' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      item_params = {merchant_id: 89786}
      header = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: {item: item_params}
      expect(response.status).to eq(400)

      updated_item = Item.find(item.id)

      expect(updated_item.merchant).to eq(merchant)
    end
  end
end
