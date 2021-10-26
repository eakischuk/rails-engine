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
  end
end
