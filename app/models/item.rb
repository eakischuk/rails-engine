class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, numericality: true

  def self.price_below(max)
    where('unit_price <= ?', max)
    .order(unit_price: :asc)
  end

  def self.price_above(min)
    where('unit_price >= ?', min)
    .order(unit_price: :asc)
  end

  def self.in_price_range(min, max)
    max_items = price_below(max)
    max_items.price_above(min)
  end
end
