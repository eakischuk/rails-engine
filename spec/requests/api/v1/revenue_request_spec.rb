require 'rails_helper'

RSpec.describe 'Revenue API' do
  before(:each) do
    @invoice_1 = create(:invoice, created_at: '1999-05-22') # revenue 10
    @invoice_2 = create(:invoice, created_at: '2000-02-04') # revenue 30
    @invoice_3 = create(:invoice, created_at: '2002-04-15') # failed; revenue 4
    @invoice_4 = create(:invoice, created_at: '2005-03-24') # revenue 40

    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, quantity: 2, unit_price: 5)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, quantity: 2, unit_price: 15)
    @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, quantity: 2, unit_price: 2)
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, quantity: 2, unit_price: 20)

    @transaction_1 = create(:transaction, invoice: @invoice_1)
    @transaction_2 = create(:transaction, invoice: @invoice_2)
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failed')
    @transaction_4 = create(:transaction, invoice: @invoice_4)
  end

  describe '/api/v1/revenue?start_date&end_date' do
    it 'returns total revenue for given date range' do
      get '/api/v1/revenue?start=2000-02-04&end=2005-04-25'

      expect(response).to be_successful

      total_revenue = JSON.parse(response.body, symbolize_names: true)

      expect(total_revenue).to be_a(Hash)
      expect(total_revenue).to have_key(:data)
      expect(total_revenue[:data]).to be_a(Hash)

      expect(total_revenue[:data]).to have_key(:id)
      expect(total_revenue[:data][:id].nil?).to eq(true)

      expect(total_revenue[:data]).to have_key(:attributes)
      expect(total_revenue[:data][:attributes]).to be_a(Hash)
      expect(total_revenue[:data][:attributes]).to have_key(:revenue)
    end

    it 'returns error for incomplete date range' do
      get '/api/v1/revenue?start=2002-02-04'
      expect(response.status).to eq(400)

      get '/api/v1/revenue?end=2002-02-04'
      expect(response.status).to eq(400)

      get '/api/v1/revenue'
      expect(response.status).to eq(400)
    end
  end
end
