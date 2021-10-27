require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'class methods' do
    before(:each) do
      @item_1 = create(:item, name: "Strawberry bouquette", unit_price: 50.56)
      @item_2 = create(:item, name: "Berrylicious Boba kit", unit_price: 5.56)
      @item_3 = create(:item, name: "Jingle Berry", unit_price: 15.56)
      @item_4 = create(:item, name: "no fruit at all", unit_price: 0.56)
    end
    it 'finds items by name ordered alphabetically' do
      expect(Item.search_by_name('berry')).to eq([@item_2, @item_3, @item_1])
    end

    it 'finds items within a price range, inclusively' do
      expect(Item.in_price_range(5, 50)).to eq([@item_2, @item_3])
      expect(Item.in_price_range(5.56, 50.56)).to eq([@item_2, @item_3, @item_1])
      expect(Item.in_price_range(60, 100)).to eq([])
    end

    it 'finds items cheaper than or equal to a given price, inclusive' do
      expect(Item.price_below(15.56)).to eq([@item_4, @item_2, @item_3])
      expect(Item.price_below(0.50)).to eq([])
    end

    it 'finds items more expensive than give price, inclusive' do
      expect(Item.price_above(20)).to eq([@item_1])
      expect(Item.price_above(15.56)).to eq([@item_3, @item_1])
    end
  end
end
