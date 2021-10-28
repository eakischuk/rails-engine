require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe '/merchants' do
    it 'sends a list of merchants' do
      create_list(:merchant, 4)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)

      merch_data = merchants[:data]
      merch_data.each do |merch|
        expect(merch).to have_key(:id)
        expect(merch[:id]).to be_an(String)

        expect(merch).to have_key(:attributes)
        expect(merch[:attributes]).to be_a(Hash)

        expect(merch[:attributes]).to have_key(:name)
        expect(merch[:attributes][:name]).to be_a(String)
      end
    end

    it 'by default sends 20 merchants per page and defaults to page 1' do
      create_list(:merchant, 25)

      get '/api/v1/merchants'

      expect(response).to be_successful

      page_default = JSON.parse(response.body, symbolize_names: true)

      expect(page_default[:data].count).to eq(20)

      get '/api/v1/merchants?page=1'

      page_1 = JSON.parse(response.body, symbolize_names: true)

      expect(page_1[:data]).to eq(page_default[:data])

      get '/api/v1/merchants?page=2'

      page_2 = JSON.parse(response.body, symbolize_names: true)

      expect(page_2[:data].count).to eq(5)
      expect(page_2[:data]).to_not eq(page_1[:data])
    end

    it 'allows user to specify per page' do
      create_list(:merchant, 55)

      get '/api/v1/merchants?per_page=50'

      page_1 = JSON.parse(response.body, symbolize_names: true)

      expect(page_1[:data].count).to eq(50)

    end

    it 'returns no data for empty pages' do
      create_list(:merchant, 20)
      get '/api/v1/merchants?page=2'

      page_2 = JSON.parse(response.body, symbolize_names: true)

      expect(page_2[:data].empty?).to eq(true)
    end
  end

  describe '/merchants/:id' do
    it 'retrieves single merchant record' do
      merchant_1 = create(:merchant)
      get "/api/v1/merchants/#{merchant_1.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to be_a(Hash)

      merchant_data = merchant[:data]

      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_a(String)

      expect(merchant_data).to have_key(:type)
      expect(merchant_data[:type]).to be_a(String)

      expect(merchant_data).to have_key(:attributes)
      expect(merchant_data[:attributes]).to be_a(Hash)

      expect(merchant_data[:attributes]).to have_key(:name)
      expect(merchant_data[:attributes][:name]).to be_a(String)
    end

    it 'returns a 400 error when no merchant found' do
      get '/api/v1/merchants/999999'
      expect(response.status).to eq(404)
    end
  end

  describe '/api/v1/merchants/most_items?quantity=x' do
    before(:each) do
      @merchant_1 = create(:merchant) # revenue: 60, items sold: 3
      @merchant_2 = create(:merchant) # revenue: 30 w/ failure; 80 if all successful, items sold: 4
      @merchant_3 = create(:merchant) # revenue: 40, items sold: 2
      @merchant_4 = create(:merchant)
      @merchant_5 = create(:merchant)
      @merchant_6 = create(:merchant)
      @merchant_7 = create(:merchant)

      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_2)
      @item_3 = create(:item, merchant: @merchant_3)
      @item_4 = create(:item, merchant: @merchant_4)
      @item_5 = create(:item, merchant: @merchant_5)
      @item_6 = create(:item, merchant: @merchant_6)
      @item_7 = create(:item, merchant: @merchant_7)

      @invoice_1 = create(:invoice) #successful
      @invoice_2 = create(:invoice) #successful
      @invoice_3 = create(:invoice) #successful

      @transaction_1 = create(:transaction, invoice: @invoice_1) #success
      @transaction_2 = create(:transaction, invoice: @invoice_2) #success
      @transaction_3 = create(:transaction, invoice: @invoice_3) #success

      @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1)
      @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2)
      @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_3)
      @invoice_item_4 = create(:invoice_item, invoice: @invoice_1, item: @item_4)
      @invoice_item_5 = create(:invoice_item, invoice: @invoice_2, item: @item_5)
      @invoice_item_6 = create(:invoice_item, invoice: @invoice_3, item: @item_6)

      @invoice_item_7 = create(:invoice_item, invoice: @invoice_1, item: @item_7, quantity: 2, unit_price: 20)
    end
    
    it 'returns a list of merchants of given length' do
      get '/api/v1/merchants/most_items?quantity=6'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data].count).to eq(6)

      merch_data = merchants[:data]
      merch_data.each do |merch|
        expect(merch).to have_key(:id)
        expect(merch[:id]).to be_a(String)

        expect(merch).to have_key(:type)
        expect(merch[:type]).to be_a(String)

        expect(merch).to have_key(:attributes)
        expect(merch[:attributes]).to be_a(Hash)

        expect(merch[:attributes]).to have_key(:name)
        expect(merch[:attributes][:name]).to be_a(String)

        expect(merch[:attributes]).to have_key(:count)
        expect(merch[:attributes][:count]).to be_a(Integer)
      end
    end

    it 'returns error if quantity a string' do
      get '/api/v1/merchants/most_items?quantity=hsakldfh'
      expect(response.status).to eq(400)
    end

    it 'returns error if no quantity given' do
      get '/api/v1/merchants/most_items'
      expect(response.status).to eq(400)
    end
  end
end
