require 'rails_helper'

RSpec.describe 'Items Merchant API' do
  describe '/api/vi/items/:id/merchant' do
    it 'returns merchant info for given item' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)

      get "/api/v1/items/#{item_1.id}/merchant"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant).to be_a(Hash)
      expect(merchant).to have_key(:data)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)

      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_a(String)

      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)

      merch_attr = merchant[:data][:attributes]
      expect(merch_attr).to have_key(:name)
      expect(merch_attr[:name]).to be_a(String)
    end

    it 'returns 404 for incorrect item ids' do
      get "/api/v1/items/765875/merchant"

      expect(response.status).to eq(404)

      get "/api/v1/items/kjasdlhfg/merchant"

      expect(response.status).to eq(404)
    end
  end
end
