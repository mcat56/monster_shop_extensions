require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to :user }
    it { should belong_to(:address) }
    it { should have_many :item_orders}
    it { should have_many(:items).through(:item_orders) }
  end

  describe 'instance methods' do
    before :each do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = user.orders.create!(name: 'Meg', address: address_1)

      @order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, merchant: @meg)
      @order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, merchant: @brian)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'fulfill' do
      expect(@order_1.status).to eq('pending')

      Order.fulfill(@order_1.id)
      @order_1.reload

      expect(@order_1.status).to eq('packaged')
    end

    it 'merchant item_count' do
      expect(@order_1.item_count).to eq(2)
    end

    it 'merchant item quantity' do
      expect(@order_1.merchant_item_quantity(@meg)).to eq(2)
      expect(@order_1.merchant_item_quantity(@brian)).to eq(3)
    end

    it 'merchant total value' do
      expect(@order_1.merchant_total_value(@meg)).to eq(200)
      expect(@order_1.merchant_total_value(@brian)).to eq(30)
    end
  end
end
