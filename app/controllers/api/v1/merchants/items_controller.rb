module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items) if merch_id_valid?
        end
      end
    end
  end
end
