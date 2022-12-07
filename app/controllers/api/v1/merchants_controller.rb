module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.new(merchant)
      end
    end
  end
end