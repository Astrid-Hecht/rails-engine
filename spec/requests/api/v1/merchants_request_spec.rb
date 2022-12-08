require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    created_merchants = create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.keys).to eq([:data])
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each_with_index do |merchant, index|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).not_to match(/\D/)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:attributes][:name]).to eq(created_merchants[index].name)
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

  context "merchant items" do
    it "sends a list of merchant's items if id is valid" do
      merc1 = create(:merchant)

      _item1 = create(:item, merchant: merc1)
      _item2 = create(:item, merchant: merc1)
      _item3 = create(:item, merchant: merc1)

      get "/api/v1/merchants/#{merc1.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_an Array
      expect(parsed[:data].count).to eq(merc1.items.count)

      data = parsed[:data]

      data.each_with_index do |item, index|
        expect(item).to have_key(:id)
        expect(item[:id]).not_to match(/\D/)

        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item')

        expect(item).to have_key(:attributes)

        item_deets = item[:attributes]
        expect(item_deets).to have_key(:name)
        expect(item_deets).to have_key(:description)
        expect(item_deets).to have_key(:unit_price)
        expect(item_deets).to have_key(:merchant_id)

        db_item = merc1.items[index]

        expect(item_deets[:name]).to eq(db_item.name)
        expect(item_deets[:description]).to eq(db_item.description)
        expect(item_deets[:unit_price]).to eq(db_item.unit_price)
        expect(item_deets[:merchant_id]).to eq(merc1.id)
      end
    end

    it 'sends 404 if id is not valid' do 
      bad_id = 8923987297
      expect { get "/api/v1/merchants/#{bad_id}/items" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end