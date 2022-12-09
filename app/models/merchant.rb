class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices, dependent: :destroy

  def self.valid_search?(params)
    return true if params[:name].present? && params[:name].is_a?(String) && params[:name] != ''

    false
  end

  def self.search_all(params)
    Merchant.where('name ILIKE ?', "%#{params[:name]}%").order(:name)
  end
end
