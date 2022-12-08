module Api
  module V1
    class ItemMerchantController < ApplicationController
      def show
        if item_id_valid?
          render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
        else
          render json: ErrorSerializer.new(Error.new('Invalid item id', 'NOT FOUND', 404)).serialized_json, status: :not_found
        end
      end
    end
  end
end
