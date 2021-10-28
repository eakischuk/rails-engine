require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before(:each) do
    @merchant_1 = create(:merchant) # revenue: 60, items sold: 3
    @merchant_2 = create(:merchant) # revenue: 30 w/ failure; 80 if all successful, items sold: 4
    @merchant_3 = create(:merchant) # revenue: 40, items sold: 2

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)

    @item_4 = create(:item, merchant: @merchant_2)
    @item_5 = create(:item, merchant: @merchant_2)
    @item_6 = create(:item, merchant: @merchant_2)

    @item_7 = create(:item, merchant: @merchant_3)
    @item_8 = create(:item, merchant: @merchant_3)
    @item_9 = create(:item, merchant: @merchant_3)

    @invoice_1 = create(:invoice) #successful
    @invoice_2 = create(:invoice) #successful
    @invoice_3 = create(:invoice) #failure

    @transaction_1 = create(:transaction, invoice: @invoice_1) #success
    @transaction_2 = create(:transaction, invoice: @invoice_2) #success
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'failed')

    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 2, unit_price: 15)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2, quantity: 1, unit_price: 30)

    @invoice_item_3 = create(:invoice_item, invoice: @invoice_1, item: @item_4, quantity: 2, unit_price: 10)
    @invoice_item_4 = create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 2, unit_price: 5)
    @invoice_item_5 = create(:invoice_item, invoice: @invoice_3, item: @item_6, quantity: 2, unit_price: 25)

    @invoice_item_6 = create(:invoice_item, invoice: @invoice_1, item: @item_7, quantity: 2, unit_price: 20)
  end
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    it 'should return a list of given length ordered by revenue desc' do
      expect(Merchant.by_revenue(1)).to eq([@merchant_1])
      expect(Merchant.by_revenue(3)).to eq([@merchant_1, @merchant_3, @merchant_2])
    end

    it 'returns list of given length ordered by items sold' do
      expect(Merchant.by_items_sold(1)).to eq([@merchant_2])
      items_sold_merch_2 = Merchant.by_items_sold(1).first.items_sold
      expect(items_sold_merch_2).to eq(4)

      expect(Merchant.by_items_sold(3)).to eq([@merchant_2, @merchant_1, @merchant_3])
    end
  end

  describe 'instance methods' do
    it 'returns total revenue for single merchant' do
      expect(@merchant_1.total_revenue).to eq(60)
      expect(@merchant_2.total_revenue).to eq(30)
      expect(@merchant_3.total_revenue).to eq(40)
    end
  end
end
