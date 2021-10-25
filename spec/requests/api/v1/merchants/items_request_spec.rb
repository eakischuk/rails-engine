require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  describe '/merchants/:id/items' do
    it 'returns a list of only that merchants items' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)

      item_4 = create(:item, merchant: merchant_2)
      item_5 = create(:item, merchant: merchant_2)

      get "/api/v1/merchants/#{merchant_1.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(3)

      item_data = items[:data]

      item_data.each do |item|
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

    it 'returns no data for merchant without items' do
      merchant_1 = create(:merchant)
      get "/api/v1/merchants/#{merchant_1.id}/items"

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(0)
    end

    it 'returns 404 when merchant not found' do
      get "/api/v1/merchants/999999/items"
      expect(response.status).to eq(404)
    end
  end
end
