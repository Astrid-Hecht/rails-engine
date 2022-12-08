require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
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

  context "a single item" do
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
      bad_id = 8923987297
      expect { get "/api/v1/items/#{bad_id}" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end