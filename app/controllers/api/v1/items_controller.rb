module Api
  module V1
    class ItemsController < ApplicationController

      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id])) if item_id_valid?
      end

      def create
        item = Item.new(item_params)
        if item.save
          render json: ItemSerializer.new(item), status: :created
        else
          render_bad_request
        end
      end

      def update
        return unless item_id_valid?
        return unless update_valid?

        Item.find(params[:id]).update(item_params)
        render json: ItemSerializer.new(Item.find(params[:id])), status: 200
      end

      def destroy
        render json: ItemSerializer.new(Item.destroy(params[:id])), status: :no_content if item_id_valid?
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def update_valid?
        return render_bad_request unless params[:item].present? && params[:item].keys.count.positive?
        return true if params[:item][:merchant_id].nil?
        return render_merchant_not_found unless merch_id_list.include?(params[:item][:merchant_id].to_i)

        true
      end
    end
  end
end
