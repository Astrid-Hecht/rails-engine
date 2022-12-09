class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def invoice_check
    invoices_w_item = self.invoices
    invoices_w_item.each do |invoice|
      invoice.destroy if invoice.items == [self]
    end
  end

  def self.valid_search?(params)
    keys = params.keys.map(&:to_sym)
    keys << params.keys.map(&:to_s)

    return false if keys.include?(:name) && (keys.include?(:min_price) || keys.include?(:max_price))
    return true if params[:name].present? && params[:name].is_a?(String) && params[:name] != ''

    if keys.include?(:min_price) && keys.include?(:max_price)
      return false unless (params[:min_price].present? && params[:min_price] != '') && (params[:max_price].present? && params[:max_price] != '')
      return false if params[:min_price].to_f > params[:max_price].to_f
    end
    return false if params[:max_price].present? && !params[:max_price].to_f.positive? 
    return false if params[:min_price].present? && !params[:min_price].to_f.positive?
    return true if (params[:min_price].present? && params[:min_price] != '') || (params[:max_price].present? && params[:max_price] != '')

    false
  end

  def self.search_one(params)
    if params[:name].present? && params[:name].is_a?(String) && params[:name] != ''
      Item.where('name ILIKE ?', "%#{params[:name]}%").order(:name).first
    elsif (params[:min_price].present? && params[:min_price] != '') || (params[:max_price].present? && params[:max_price] != '')
      price_logic(params)
    end
  end

  def self.price_logic(params)
    if params[:max_price].present? && params[:min_price].present?
      return Item.where('unit_price < ? AND unit_price > ?', params[:max_price], params[:min_price]).order(:name).first
    end
    return Item.where('unit_price < ?', params[:max_price]).order(:name).first if params[:max_price].present?
    return Item.where('unit_price > ?', params[:min_price]).order(:name).first if params[:min_price].present?
  end
end
