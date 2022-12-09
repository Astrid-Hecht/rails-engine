require 'rails_helper'

describe 'Search API' do
  context 'a single item' do
    it 'can search for a item with perfect matching name' do
      merchant = create(:merchant)
      target_item = create(:item, name: 'Bitumen', merchant: merchant)
      unwanted_item = create(:item, name: 'Max Lumen Lightbulbs', merchant: merchant)

      get '/api/vi/items/find?name=bitumen'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.keys).to eq([:data])
      expect(merchants[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(target_item.name)
      expect(item[:name]).not_to eq(unwanted_item.name)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq(target_item.description)
      expect(item[:description]).not_to eq(unwanted_item.description)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(target_item.unit_price)
      expect(item[:unit_price]).not_to eq(unwanted_item.unit_price)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(target_item.merchant_id)
      expect(item[:merchant_id]).not_to eq(unwanted_item.merchant_id)
    end

    it 'can search for a item with name fragment and return first item alphabetically' do
      merchant = create(:merchant)
      target_item = create(:item, name: 'Bitumen', merchant: merchant)
      unwanted_item = create(:item, name: 'Max Lumen Lightbulbs', merchant: merchant)

      get '/api/vi/items/find?name=umen'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.keys).to eq([:data])
      expect(merchants[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(target_item.name)
      expect(item[:name]).not_to eq(unwanted_item.name)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq(target_item.description)
      expect(item[:description]).not_to eq(unwanted_item.description)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(target_item.unit_price)
      expect(item[:unit_price]).not_to eq(unwanted_item.unit_price)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(target_item.merchant_id)
      expect(item[:merchant_id]).not_to eq(unwanted_item.merchant_id)
    end

    it 'can search for a item with max price and return first item under threshold alphabetically' do
      merchant = create(:merchant)
      target_item = create(:item, name: 'Bitumen', unit_price: 1.35, merchant: merchant)
      unwanted_item = create(:item, name: 'Max Lumen Lightbulbs', unit_price: 103.34, merchant: merchant)
      _unwanted_item2 = create(:item, name: 'who cares', unit_price: 4.99, merchant: merchant)

      get '/api/vi/items/find?max_price=5.00'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.keys).to eq([:data])
      expect(merchants[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(target_item.name)
      expect(item[:name]).not_to eq(unwanted_item.name)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq(target_item.description)
      expect(item[:description]).not_to eq(unwanted_item.description)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(target_item.unit_price)
      expect(item[:unit_price]).not_to eq(unwanted_item.unit_price)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(target_item.merchant_id)
      expect(item[:merchant_id]).not_to eq(unwanted_item.merchant_id)
    end

    it 'can search for a item with min price and return first item under threshold alphabetically' do
      merchant = create(:merchant)
      target_item = create(:item, name: 'Bitumen', unit_price: 25.35, merchant: merchant)
      unwanted_item = create(:item, name: 'Max Lumen Lightbulbs', unit_price: 103.34, merchant: merchant)
      __unwanted_item2 = create(:item, name: 'who cares', unit_price: 4.99, merchant: merchant)

      get '/api/vi/items/find?max_price=20.00'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.keys).to eq([:data])
      expect(merchants[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(target_item.name)
      expect(item[:name]).not_to eq(unwanted_item.name)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq(target_item.description)
      expect(item[:description]).not_to eq(unwanted_item.description)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(target_item.unit_price)
      expect(item[:unit_price]).not_to eq(unwanted_item.unit_price)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(target_item.merchant_id)
      expect(item[:merchant_id]).not_to eq(unwanted_item.merchant_id)
    end

    it 'can search for a item with max & min price and return first item under threshold alphabetically' do
      merchant = create(:merchant)
      target_item = create(:item, name: 'Bitumen', unit_price: 25.35, merchant: merchant)
      unwanted_item = create(:item, name: 'Max Lumen Lightbulbs', unit_price: 103.34, merchant: merchant)
      _unwanted_item2 = create(:item, name: 'who cares', unit_price: 4.99, merchant: merchant)
      _unwanted_item3 = create(:item, name: 'zumba dvd', unit_price: 24.99, merchant: merchant)

      get '/api/vi/items/find?max_price=30.00&min_price=20.00'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.keys).to eq([:data])
      expect(merchants[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(target_item.name)
      expect(item[:name]).not_to eq(unwanted_item.name)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq(target_item.description)
      expect(item[:description]).not_to eq(unwanted_item.description)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(target_item.unit_price)
      expect(item[:unit_price]).not_to eq(unwanted_item.unit_price)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(target_item.merchant_id)
      expect(item[:merchant_id]).not_to eq(unwanted_item.merchant_id)
    end

    it 'returns error w search for a item with max and/or min price and name fragment' do
      merchant = create(:merchant)
      _target_item = create(:item, name: 'Bitumen', unit_price: 25.35, merchant: merchant)
      _unwanted_item = create(:item, name: 'Max Lumen Lightbulbs', unit_price: 103.34, merchant: merchant)
      _unwanted_item2 = create(:item, name: 'who cares', unit_price: 4.99, merchant: merchant)
      _unwanted_item3 = create(:item, name: 'zumba dvd', unit_price: 24.99, merchant: merchant)

      get '/api/vi/items/find?min_price=20.00&name=umen'

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:error)
      expect(parsed[:error]).to be_a Array

      expect(parsed[:error][0]).to have_key(:status)
      expect(parsed[:error][0]).to have_key(:message)
      expect(parsed[:error][0]).to have_key(:code)

      get '/api/vi/items/find?max_price=200.00&name=umen'

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:error)
      expect(parsed[:error]).to be_a Array

      expect(parsed[:error][0]).to have_key(:status)
      expect(parsed[:error][0]).to have_key(:message)
      expect(parsed[:error][0]).to have_key(:code)

      get '/api/vi/items/find?min_price=20.00&max_price=200.00&name=umen'

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:error)
      expect(parsed[:error]).to be_a Array

      expect(parsed[:error][0]).to have_key(:status)
      expect(parsed[:error][0]).to have_key(:message)
      expect(parsed[:error][0]).to have_key(:code)
    end
  end
end
