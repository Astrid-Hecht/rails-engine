class Merchant < ApplicationRecord
  validates :name, presence: true
  # validates :enabled, inclusion: [true, false]

  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices, dependent: :destroy
end
