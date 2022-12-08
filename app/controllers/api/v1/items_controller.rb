module Api
  module V1
    class ItemsController < ApplicationController

      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        # binding.pry
        if item_id_valid?
          render json: ItemSerializer.new(Item.find(params[:id]))
        else
          render json: ErrorSerializer.new(Error.new('Invalid item id', 'NOT FOUND', 404)).serialized_json, status: :not_found
        end
      end

      def create
        render json: ItemSerializer.new(Item.create(item_params)), status: :created
      end

      def update
        if item_id_valid?
          if update_valid?
            Item.find(params[:id]).update(item_params)
            render json: ItemSerializer.new(Item.find(params[:id]))
          else
            render json: ErrorSerializer.new(Error.new('Missing or invalid item paramters', 'BAD REQUEST', 400)).serialized_json, status: :bad_request
          end
        else
          render json: ErrorSerializer.new(Error.new('Invalid item id', 'NOT FOUND', 404)).serialized_json, status: :not_found
        end
      end

      def destroy
        if item_id_valid?
          render json: ItemSerializer.new(Item.destroy(params[:id])), status: :no_content
        else
          render json: ErrorSerializer.new(Error.new('Invalid item id', 'NOT FOUND', 404)).serialized_json, status: :not_found
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def update_valid?
        if params[:item].present? && params[:item].keys.count > 0 
          if params[:item][:merchant_id].present?
            merch_id_list.include?(params[:item][:merchant_id].to_i)
          else
            true
          end
        else
          false
        end
      end
    end
  end
end
