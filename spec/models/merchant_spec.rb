require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :items }
    it { should have_many :item_orders }
    it { should have_many :users }
    it { should have_many :coupons }
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end
    it 'disable and enable' do
      expect(@meg.enabled?).to eq(true)
      @meg.disable
      @meg.reload

      expect(@meg.enabled?).to eq(false)

      @meg.enable

      @meg.reload
      expect(@meg.enabled?).to eq(true)
    end

    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')


      order_1 = user.orders.create!(name: 'Meg',  address: address_1)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')
      address_2 = user.addresses.create(street: '87 Beach Way', city: 'Miami', state: 'Florida', zip: '33130')
      address_3 = user.addresses.create(street: '252 Pawnee Avenue', city: 'Pawnee', state: 'Indiana', zip: '80503')

      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = user.orders.create!(name: 'Meg', address: address_1)
      order_2 = user.orders.create!(name: 'Brian', address: address_2)
      order_3 = user.orders.create!(name: 'Dao', address: address_3)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2, merchant: @meg)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)

      expect(@meg.distinct_cities).to contain_exactly("Honolulu","Miami", "Pawnee")
    end

  end
end
