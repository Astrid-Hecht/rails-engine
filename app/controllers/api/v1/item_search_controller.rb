module Api
  module V1
    class ItemSearchController < V1Controller
      def show
        return render_bad_request unless Item.valid_search?(params)

        item = Item.search_one(search_params)
        return render_search_item_not_found unless item != nil

        render json: ItemSerializer.new(Item.search_one(search_params)), status: 200
      end

      private

      def search_params
        params.permit(:name, :min_price, :max_price)
      end
    end
  end
end
