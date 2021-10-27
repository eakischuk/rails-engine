require 'rails_helper'

RSpec.describe 'Merchants Search API' do
  describe '/api/v1/merchants/find' do
    before(:each) do
      @merchant_1 = create(:merchant, name: "Sundials Inc.")
      @merchant_2 = create(:merchant, name: "Dials Dials Dials")
      @merchant_3 = create(:merchant, name: "Watches.")
    end
    it 'finds single merchant by name search' do
      get '/api/v1/merchants/find?name=dial'

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)
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
      expect(merchant_data[:attributes][:name]).to eq(@merchant_2.name)
    end

    it 'returns empty data set if not found' do
      get '/api/v1/merchants/find?name=phone'

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)
    end

    it 'returns 400 error if no params' do
      get '/api/v1/merchants/find'

      expect(response.status).to eq(400)
    end
  end
end
