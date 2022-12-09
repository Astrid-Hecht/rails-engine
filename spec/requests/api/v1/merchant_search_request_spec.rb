require 'rails_helper'

describe 'Search API' do
  context 'a list of merchants' do
    it 'can search for merchants with perfect matching name' do
      target_merchant = create(:merchant, name: 'Bill')
      unwanted_merchant = create(:merchant, name: 'Zill')

      get '/api/v1/merchants/find_all?name=bill'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed.keys).to eq([:data])
      expect(parsed[:data]).to be_an Array
      expect(parsed[:data].count).to eq(1)

      data = parsed[:data][0]

      expect(data).to have_key(:id)
      expect(data[:id]).not_to match(/\D/)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('merchant')

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_an Hash

      item = data[:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item[:name]).to eq(target_merchant.name)
      expect(item[:name]).not_to eq(unwanted_merchant.name)
    end

    it 'can search for multiple merchants w a matching name fragment' do
      target_merchant1 = create(:merchant, name: 'Billbo')
      target_merchant2 = create(:merchant, name: 'Abill')
      _unwanted_merchant = create(:merchant, name: 'Zill')

      get '/api/v1/merchants/find_all?name=bill'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed.keys).to eq([:data])
      expect(parsed[:data]).to be_an Array
      expect(parsed[:data].count).to eq(2)

      expected_data_order = [target_merchant2, target_merchant1]

      data = parsed[:data]

      data.each_with_index do |merch, index|
        expect(merch).to have_key(:id)
        expect(merch[:id]).not_to match(/\D/)
        expect(merch[:id].to_i).to eq(expected_data_order[index].id)

        expect(merch).to have_key(:type)
        expect(merch[:type]).to eq('merchant')

        expect(merch).to have_key(:attributes)
        expect(merch[:attributes]).to be_a Hash

        item = merch[:attributes]

        expect(item).to have_key(:name)
        expect(item[:name]).to be_a(String)
        expect(item[:name]).to eq(expected_data_order[index].name)
      end
    end

    it 'will return an array, even if no results are found' do
      _target_merchant = create(:merchant, name: 'Bill')
      _unwanted_merchant = create(:merchant, name: 'Zill')

      get '/api/v1/merchants/find_all?name=abcdefghijklmnop'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:data)
      expect(parsed[:data]).to be_a Array
      expect(parsed[:data]).to eq([])

      expect(parsed).to have_key(:error)
      expect(parsed[:error]).to be_a Hash

      expect(parsed[:error]).to have_key(:status)
      expect(parsed[:error]).to have_key(:error_message)
      expect(parsed[:error]).to have_key(:code)
    end

    it 'returns error w empty search param' do
      merchant = create(:merchant)
      _target_item = create(:item, name: 'Bitumen', unit_price: 25.35, merchant: merchant)
      _unwanted_item = create(:item, name: 'Max Lumen Lightbulbs', unit_price: 103.34, merchant: merchant)
      _unwanted_item2 = create(:item, name: 'who cares', unit_price: 4.99, merchant: merchant)
      _unwanted_item3 = create(:item, name: 'zumba dvd', unit_price: 24.99, merchant: merchant)

      get '/api/v1/merchants/find_all'

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      parsed = JSON.parse(response.body, symbolize_names: true)

      expect(parsed).to have_key(:error)
      expect(parsed[:error]).to be_a Array

      expect(parsed[:error][0]).to have_key(:status)
      expect(parsed[:error][0]).to have_key(:message)
      expect(parsed[:error][0]).to have_key(:code)

      get '/api/v1/merchants/find_all?name='

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
