require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.keys).to eq([:data])
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each_with_index do |merchant, index|
      # binding.pry
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).not_to match(/\D/)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:attributes][:name]).to eq(Merchant.find_by(id: index + 1).name)
    end
  end

  context "a single merchant" do
    it 'is sent if id is valid' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_a Hash

      data = parsed[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('merchant')

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to have_key(:name)
      expect(data[:attributes][:name]).to eq(Merchant.find(id).name)
    end

    it 'sends 404 if id is not valid' do 
      bad_id = 8923987297
      expect { get "/api/v1/merchants/#{bad_id}" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it "sends a list of merchant's items" do

  end
end