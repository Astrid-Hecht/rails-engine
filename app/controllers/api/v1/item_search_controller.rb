module Api
  module V1
    class ItemSearchController < ApplicationController
      def show
        # binding.pry
        return render_bad_request unless Item.valid_search?(params)
        render json: ItemSerializer.new(Item.search_one(search_params)), status: 200
      end

      private

      def search_params
        params.permit(:name, :min_price, :max_price)
      end
    end
  end
end