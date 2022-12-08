class ApplicationController < ActionController::API
  def merch_id_valid?
    merchant_ids = merch_id_list
    if params[:merchant_id].present?
      merchant_ids.include?(params[:merchant_id].to_i)
    else
      merchant_ids.include?(params[:id].to_i)
    end
  end

  def item_id_valid?
    item_ids = Item.all.map(&:id)
    item_ids.include?(params[:id].to_i)
  end

  def merch_id_list
    Merchant.all.map(&:id)
  end
end
