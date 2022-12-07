module Api
  module V1
      class ItemsController < ApplicationController
        def index
          render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
        end
      end
  end
end
