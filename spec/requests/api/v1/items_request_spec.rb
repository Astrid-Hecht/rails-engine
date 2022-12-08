require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:merchant, 3)
    create_list(:item, 10)

    get '/api/v1/items'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.keys).to eq([:data])
    expect(items[:data]).to be_an Array
    expect(items[:data].count).to eq(10)

    items[:data].each_with_index do |item, index|
      expect(item).to have_key(:id)
      expect(item[:id]).not_to match(/\D/)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:name]).to eq(Item.find_by(id: index + 1).name)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:description]).to eq(Item.find_by(id: index + 1).description)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:unit_price]).to eq(Item.find_by(id: index + 1).unit_price)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:attributes][:merchant_id]).to eq(Item.find_by(id: index + 1).merchant_id)
    end
  end

  context 'a single item' do
    it 'is sent if id is valid' do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(Item.find(id).name)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq(Item.find(id).description)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(Item.find(id).unit_price)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(Item.find(id).merchant_id)
    end

    it 'sends 404 if id is not valid' do
      get "/api/v1/items/8923987297"
      expect(response.status).to eq(404)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:errors)
      expect(parsed[:errors]).to be_a Array

      expect(parsed[:errors][0]).to have_key(:status)
      expect(parsed[:errors][0]).to have_key(:message)
      expect(parsed[:errors][0]).to have_key(:code)
    end
  end

  context 'it can create and delete one item' do
    it 'creates one when attributes are passed in' do
      create(:merchant, id: 43)

      item_params = {
        name: 'Shiny Itemy Item',
        description: 'It does a lot of things real good.',
        unit_price: 123.45,
        merchant_id: 43
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      item = Item.last
      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(item_params[:name])

      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq(item_params[:description])

      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(item_params[:unit_price])

      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(item_params[:merchant_id])
    end

    it 'can destroy item if passed id' do
      create(:merchant)
      first = create(:item, name: 'first')
      second = create(:item, name: 'second')

      expect(Item.last).to eq(second)
      expect(Item.last).not_to eq(first)

      expect { delete "/api/v1/items/#{second.id}" }.to change { Item.count }.by(-1)

      expect(response.status).to eq(204)

      expect(Item.last).not_to eq(second)
      expect(Item.last).to eq(first)
    end

    it 'gives a 404 if item to destroy if id is invalid & doesnt delete anything' do
      create(:merchant)
      first = create(:item)

      expect { delete '/api/v1/items/99999999999999' }.to change { Item.count }.by(0)

      expect(response.status).to eq(404)

      expect(Item.last).to eq(first)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:errors)
      expect(parsed[:errors]).to be_a Array

      expect(parsed[:errors][0]).to have_key(:status)
      expect(parsed[:errors][0]).to have_key(:message)
      expect(parsed[:errors][0]).to have_key(:code)
    end
  end

  context 'it can update one item' do
    it 'with a full hash of data' do
      merch = create(:merchant)
      _new_merch = create(:merchant, id: 43)
      db_item = create(:item, name: 'preupdate', description: 'this is the item pre update', unit_price: 4.20,
                              merchant: merch)

      new_params = {
        name: 'Shiny Itemy Item',
        description: 'It does a lot of things real good.',
        unit_price: 69.69,
        merchant_id: 43
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      put "/api/v1/items/#{db_item.id}", headers: headers, params: JSON.generate(item: new_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).to eq(db_item.id.to_s)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq('Shiny Itemy Item')

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq('It does a lot of things real good.')

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item[:unit_price]).to eq(69.69)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(43)
    end

    it 'with partial data' do
      merch = create(:merchant)
      db_item = create(:item, name: 'preupdate', description: 'this is the item pre update', unit_price: 4.20,
                              merchant: merch)

      new_params = {
        description: 'It does a lot of things real good.'
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      put "/api/v1/items/#{db_item.id}", headers: headers, params: JSON.generate(item: new_params)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).to eq(db_item.id.to_s)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('item')

      expect(data).to have_key(:attributes)
      expect(data).to be_a Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(db_item.name)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item[:description]).to eq('It does a lot of things real good.')
    end

    it ', but if no data, returns error' do
      merch = create(:merchant)
      db_item = create(:item, name: 'preupdate', description: 'this is the item pre update', unit_price: 4.20,
                              merchant: merch)

      put "/api/v1/items/#{db_item.id}"

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:errors)
      expect(parsed[:errors]).to be_a Array

      expect(parsed[:errors][0]).to have_key(:status)
      expect(parsed[:errors][0]).to have_key(:message)
      expect(parsed[:errors][0]).to have_key(:code)
    end

    it ', but if invalid id, returns 404' do
      merch = create(:merchant)
      _db_item = create(:item, name: 'preupdate', description: 'this is the item pre update', unit_price: 4.20,
                              merchant: merch)

      put "/api/v1/items/999999999999999999"

      expect(response).not_to be_successful
      expect(response.status).to eq(404)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:errors)
      expect(parsed[:errors]).to be_a Array
      expect(parsed[:errors][0]).to have_key(:status)
      expect(parsed[:errors][0]).to have_key(:message)
      expect(parsed[:errors][0]).to have_key(:code)
    end
  end
end
