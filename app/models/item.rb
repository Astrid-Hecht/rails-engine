class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.valid_search?(params)
    return false if params.keys.include?('name') && (params.keys.include?('min_price') || params.keys.include?('max_price'))
    return true if params[:name].present? && params[:name].is_a?(String) && params[:name] != ''
    return false if params[:max_price].to_f.negative? || params[:min_price].to_f.negative?
    return true if (params[:min_price].present? && params[:min_price] != '') || (params[:max_price].present? && params[:max_price] != '')

    false
  end

  def self.search_one(params)
    if params[:name].present? && params[:name].is_a?(String) && params[:name] != ''
      return Item.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}").order(:name).first
    elsif (params[:min_price].present? && params[:min_price] != '') || (params[:max_price].present? && params[:max_price] != '')
      return price_logic(params)
    end
  end

  def self.price_logic(params)
    if params[:max_price].present? && params[:min_price].present?
      return Item.where('unit_price < ? AND unit_price > ?', params[:max_price],
                        params[:min_price]).order(:name).first
    end
    return Item.where('unit_price < ?', params[:max_price]).order(:name).first if params[:max_price].present?
    return Item.where('unit_price > ?', params[:min_price]).order(:name).first if params[:min_price].present?
  end
end
