require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '#valid_search' do
      it 'returns true if name present and name isnt empty' do
        params = { 'name': 'Bobs bobbers' }
        expect(Merchant.valid_search?(params)).to be true
      end

      it 'returns false if name isnt present' do
        params = { 'key': 'value' }
        expect(Merchant.valid_search?(params)).to be false
      end


      it 'returns false if name is empty' do
        params = { 'Name': '' }
        expect(Merchant.valid_search?(params)).to be false
      end

      it 'returns false if name isnt a string' do
        params = { 'Name': 3523 }
        expect(Merchant.valid_search?(params)).to be false
      end
    end

    describe '#search_all' do
      let!(:merchant2) { create(:merchant, name: 'Phill') }
      let!(:merchant1) { create(:merchant, name: 'Bill') }
      let!(:merchant3) { create(:merchant, name: 'Joll') }

      it 'returns one object with a perfectly matching name' do
        expect(Merchant.search_all({ 'name': 'Phill' })).to eq([merchant2])
      end

      it 'returns matching merchants alphabetically with a name fragment' do
        expect(Merchant.search_all({ 'name': 'ill' })).to eq([merchant1, merchant2])
      end
    end
  end
end
