module Api
  module V1
    class MerchantsController < ApplicationController

      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        if merch_id_valid?
          render json: MerchantSerializer.new(Merchant.find(params[:id]))
        else
          render json: ErrorSerializer.new(Error.new('Invalid merchant id', 'NOT FOUND', 404)).serialized_json, status: :not_found
        end
      end
    end
  end
end
