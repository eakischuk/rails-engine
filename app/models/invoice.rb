class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items

  def self.destroy_empty_invoices
    empty_invoices = left_outer_joins(:invoice_items).where(invoice_items: {id: nil})
    empty_invoices.destroy_all
  end

  def self.total_revenue_between(start_date, end_date)
    joins(:invoice_items, :transactions)
    .where('transactions.result = ?', "success")
    .where('invoices.created_at >= ? AND invoices.created_at <= ?', start_date, end_date)
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
