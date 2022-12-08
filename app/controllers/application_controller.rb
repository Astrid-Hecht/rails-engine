class ApplicationController < ActionController::API
  def merch_id_valid?
    id = if params[:merchant_id].present?
           params[:merchant_id]
         else
           params[:id]
         end
    render_merchant_not_found unless merch_id_list.include?(id.to_i)
    merch_id_list.include?(id.to_i)
  end

  def item_id_valid?
    item_ids = Item.all.map(&:id)
    render_item_not_found unless item_ids.include?(params[:id].to_i)
    item_ids.include?(params[:id].to_i)
  end

  def render_item_not_found
    render json: ErrorSerializer.new(Error.new('Invalid item id', 'NOT FOUND', 404)).serialized_json, status: :not_found
    false
  end

  def render_merchant_not_found
    render json: ErrorSerializer.new(Error.new('Invalid merchant id', 'NOT FOUND', 404)).serialized_json, status: :not_found
    false
  end

  def render_bad_request
    render json: ErrorSerializer.new(Error.new('Missing or invalid item paramters', 'BAD REQUEST', 400)).serialized_json, status: :bad_request
    false
  end

  def merch_id_list
    Merchant.all.map(&:id)
  end
end
