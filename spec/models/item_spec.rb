require 'rails_helper'
RSpec.describe Item, type: :model do

#   describe 'relationships' do
#     it { should belong_to(:merchant) }
#     it { should have_many :invoice_items }
#     it { should have_many(:invoices).through(:invoice_items) }
#   end

#   describe 'validations' do
#     it { should validate_presence_of(:name) }
#     it { should validate_presence_of(:description) }
#     it { should validate_numericality_of(:unit_price) }
#   end

  describe 'instance methods' do
    describe '#invoice_check' do
      it 'checks all invoices and deletes the ones that have only that item on them' do
        merch = create(:merchant)
        cust = create(:customer)

        item1 = create(:item)
        item2 = create(:item)

        invoice1 = create(:invoice, customer: cust, merchant_id: merch.id)
        invoice2 = create(:invoice, customer: cust, merchant_id: merch.id)

        inv_item1 = create(:invoice_item, item: item1, invoice: invoice1)

        inv_item2 = create(:invoice_item, item: item1, invoice: invoice2)
        inv_item3 = create(:invoice_item, item: item2, invoice: invoice2)
        
        expect(Invoice.count).to eq(2)

        item1.invoice_check

        expect(Invoice.count).to eq(1)

        # simulating what controller does
        item1.destroy

        expect(Item.all).to eq([item2])
        expect(Invoice.all).to eq([invoice2])
        expect(InvoiceItem.all).to eq([inv_item3])
      end
    end
  end

  describe 'class methods' do
    describe '#valid_search' do
      it 'returns false if both name and keys are present' do
        params = { 'name': 'Bobs bobbers', 'min_price': '15.00' }
        expect(Item.valid_search?(params)).to be false
      end

      it 'returns true if just name and name isnt empty' do
        params = {'name': 'Bobs bobbers'}
        expect(Item.valid_search?(params)).to be true
      end

      it 'returns false if min price > max price' do
        params = {'min_price': '15.00', 'max_price': '10.00'}
        expect(Item.valid_search?(params)).to be false
      end

      it 'returns false if min price or max price are neg' do
        params = {'min_price': '-15.00', 'max_price': '100.00'}
        expect(Item.valid_search?(params)).to be false

        params = {'min_price': '15.00', 'max_price': '-100.00'}
        expect(Item.valid_search?(params)).to be false

        params = {'min_price': '-15.00', 'max_price': '-100.00'}
        expect(Item.valid_search?(params)).to be false
      end

      it 'returns true if min price and/or max price are present and arent empty' do
        params = {'min_price': '15.00'}
        expect(Item.valid_search?(params)).to be true

        params = {'max_price': '100.00'}
        expect(Item.valid_search?(params)).to be true

        params = {'min_price': '15.00', 'max_price': '100.00'}
        expect(Item.valid_search?(params)).to be true
      end

      it 'returns false if any key is empty' do
        params = {'min_price': ''}
        expect(Item.valid_search?(params)).to be false
        
        params = {'max_price': ''}
        expect(Item.valid_search?(params)).to be false
        
        params = {'min_price': '', 'max_price': '100.00'}
        expect(Item.valid_search?(params)).to be false

        params = {'name': ''}
        expect(Item.valid_search?(params)).to be false
      end
    end

    describe '#search_one' do

    end

    describe '#price_logic' do

    end
  end
end