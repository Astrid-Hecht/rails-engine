module Api
  module V1
    class ItemMerchantController < V1Controller
      def show
        render json: MerchantSerializer.new(Item.find(params[:id]).merchant) if item_id_valid?
      end
    end
  end
end
