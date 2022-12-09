module Api
  module V1
    class MerchantsController < ApplicationController

      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        render json: MerchantSerializer.new(Merchant.find(params[:id])) if merch_id_valid?
      end
    end
  end
end
