require 'rails_helper'

RSpec.describe 'Merchants API' do
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
      expect(merch[:id]).to be_an(Integer)

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
    create_list(:merchant, 50)

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
