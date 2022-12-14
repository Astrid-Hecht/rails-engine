
module Api
  class V1Controller < ApplicationController
    def merch_id_valid?
      id = params[:id]
      id = params[:merchant_id] if params[:merchant_id].present?
      return render_merchant_not_found unless merch_id_list.include?(id.to_i)

      true
    end

    def item_id_valid?
      return render_item_not_found unless Item.all.map(&:id).include?(params[:id].to_i)

      true
    end

    def render_item_not_found
      render json: ErrorSerializer.new(Error.new('Invalid item id', 'NOT FOUND', 404)).serialized_json, status: :not_found
      false
    end

    def render_search_item_not_found
      render json: NoResultsSerializer.new(Error.new('No matching items found', 'OK', 200), :find_one).serialized_json, status: 200
      false
    end

    def render_merchant_not_found
      render json: ErrorSerializer.new(Error.new('Invalid merchant id', 'NOT FOUND', 404)).serialized_json, status: :not_found
      false
    end

    def render_search_merchants_not_found
      render json: NoResultsSerializer.new(Error.new('No matching merchants found', 'OK', 200), :find_all).serialized_json, status: 200
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
end