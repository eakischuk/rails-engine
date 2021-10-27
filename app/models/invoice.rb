class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items

  def self.destroy_empty_invoices
    empty_invoices = left_outer_joins(:invoice_items).where(invoice_items: {id: nil})
    empty_invoices.destroy_all
  end
end
