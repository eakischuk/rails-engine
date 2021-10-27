require 'rails_helper'

RSpec.describe 'Items Search API' do
  describe '/api/v1/items/find_all' do
    before(:each) do
      @item_1 = create(:item, name: "Strawberry bouquette", unit_price: 50.56)
      @item_2 = create(:item, name: "Berrylicious Boba kit", unit_price: 5.56)
      @item_3 = create(:item, name: "Jingle Berry", unit_price: 15.56)
      @item_4 = create(:item, name: "no fruit at all", unit_price: 0.56)
    end
    context 'name search' do
      it 'finds all items for given name' do

        get '/api/v1/items/find_all?name=berry'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(3)
        expect(items[:data][0]).to be_a(Hash)

        items[:data].each do |item|
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

      it 'returns empty array for no items found' do
        get '/api/v1/items/find_all?name=bloop'

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(0)
      end
    end

    context 'price search' do
      it 'returns items within a price range' do
        get '/api/v1/items/find_all?max_price=50&min_price=5'
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(2)
      end

      it 'returns items priced above a min' do
        get '/api/v1/items/find_all?max_price=20'
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(3)
      end

      it 'returns items priced below a max' do
        get '/api/v1/items/find_all?min_price=20'
        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(1)
      end

      it 'returns an error without params' do
        get '/api/v1/items/find_all'

        expect(response.status).to eq(400)
      end

      it 'only accepts name or price params, not both' do
        get '/api/v1/items/find_all?name=berry&min_price=20'
        expect(response.status).to eq(400)

        get '/api/v1/items/find_all?name=berry&max_price=20'
        expect(response.status).to eq(400)
      end

      it 'does not accept strings for price params' do
        get '/api/v1/items/find_all?min_price=hjh'
        expect(response.status).to eq(400)

        get '/api/v1/items/find_all?max_price=dfkjh'
        expect(response.status).to eq(400)

        get '/api/v1/items/find_all?max_price=dfkjh&min_price=34'
        expect(response.status).to eq(400)
      end
    end
  end
end
