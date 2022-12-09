module Api
  module V1
    class MerchantSearchController < ApplicationController
      def index
        return render_bad_request unless Merchant.valid_search?(params)
        merch = Merchant.search_all(search_params)
        return render_search_merchant_not_found unless merch != nil
        render json: MerchantSerializer.new(merch), status: 200
      end

      private

      def search_params
        params.permit(:name, :min_price, :max_price)
      end
    end
  end
end