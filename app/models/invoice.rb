class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items

  def self.destroy_empty_invoices
    empty_invoices = left_outer_joins(:invoice_items).where(invoice_items: {id: nil})
    empty_invoices.destroy_all
  end

  def self.start_date_format(start)
    DateTime.strptime(start, '%Y-%m-%d').beginning_of_day
  end

  def self.end_date_format(end_date)
    DateTime.strptime(end_date, '%Y-%m-%d').end_of_day
  end

  def self.total_revenue_between(start_date, end_date)
    start = start_date_format(start_date)
    end_of_date = end_date_format(end_date)
    joins(:invoice_items, :transactions)
    .where('transactions.result = ?', "success")
    .where('invoices.created_at >= ? AND invoices.created_at <= ?', start, end_of_date)
    .where('invoices.status = ?', 'shipped')
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end

end
