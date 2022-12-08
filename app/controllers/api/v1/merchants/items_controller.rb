module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController

        def index
          if merch_id_valid?
            render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
          else
            render json: ErrorSerializer.new(Error.new('Invalid merchant id', 'NOT FOUND', 404)).serialized_json, status: :not_found
          end
        end
      end
    end
  end
end
