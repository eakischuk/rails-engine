require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods' do
    it 'destroy invoices with no items' do
      item_1 = create(:item)
      item_2 = create(:item)
      invoice_1 = create(:invoice)
      invoice_2 = create(:invoice)
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)
      invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2)

      expect(Invoice.all.count).to eq(2)
      item_1.destroy
      Invoice.destroy_empty_invoices
      expect(Invoice.all.count).to eq(1)
      item_2.destroy
      Invoice.destroy_empty_invoices
      expect(Invoice.all.count).to eq(0)
    end

    it 'returns total revenue for given time range' do
      invoice_1 = create(:invoice, created_at: '1999-05-22') # revenue 10
      invoice_2 = create(:invoice, created_at: '2000-02-04') # revenue 30
      invoice_3 = create(:invoice, created_at: '2002-04-15') # failed; revenue 4
      invoice_4 = create(:invoice, created_at: '2005-03-24') # revenue 40

      invoice_item_1 = create(:invoice_item, invoice: invoice_1, quantity: 2, unit_price: 5)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, quantity: 2, unit_price: 15)
      invoice_item_3 = create(:invoice_item, invoice: invoice_3, quantity: 2, unit_price: 2)
      invoice_item_4 = create(:invoice_item, invoice: invoice_4, quantity: 2, unit_price: 20)

      transaction_1 = create(:transaction, invoice: invoice_1)
      transaction_2 = create(:transaction, invoice: invoice_2)
      transaction_3 = create(:transaction, invoice: invoice_3, result: 'failed')
      transaction_4 = create(:transaction, invoice: invoice_4)

      expect(Invoice.total_revenue_between('2000-02-04', '2005-05-06')).to eq(70)
      expect(Invoice.total_revenue_between('2020-02-04', '2021-05-03')).to eq(0)
    end

    it 'formats start date for beginning of day' do
      invoice_1 = create(:invoice, created_at: '1999-05-22') # revenue 10
      invoice_2 = create(:invoice, created_at: '2000-02-04') # revenue 30
      invoice_3 = create(:invoice, created_at: '2002-04-15') # failed; revenue 4
      invoice_4 = create(:invoice, created_at: '2005-03-24') # revenue 40

      expect(Invoice.start_date_format('2000-02-04')).to eq('Fri, 04 Feb 2000 00:00:00 +0000')
    end

    it 'formats end date for end of day' do
      expect(Invoice.end_date_format('2005-03-24')).to eq('Thu, 24 Mar 2005 23:59:59.999999999 +0000')
    end
  end
end
