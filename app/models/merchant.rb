class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.by_revenue(limit)
    joins(items: {invoice_items: {invoice: :transactions}})
    .where('transactions.result = ?', "success")
    .select("merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
    .group(:id)
    .order(revenue: :desc)
    .limit(limit)
  end

  def self.by_items_sold(limit)
    joins(items: {invoice_items: {invoice: :transactions}})
    .where('transactions.result = ?', "success")
    .select("merchants.*, SUM(invoice_items.quantity) AS items_sold")
    .group(:id)
    .order(items_sold: :desc)
    .limit(limit)
  end

  def total_revenue
    invoice_items.joins(invoice: :transactions)
    .where('transactions.result = ?', "success")
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end
end
