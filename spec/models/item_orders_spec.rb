require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to :item }
    it { should belong_to :order }
    it { should belong_to :merchant }
  end

  describe 'instance methods' do
    it 'subtotal' do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, merchant: meg)

      expect(item_order_1.subtotal).to eq(200)
    end

    it 'fulfill' do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 20)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 12, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_treats = @brian.items.create(name: "Dog Treats", description: "Pretty good dog treats. My dog liked them.", price: 11, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 25)
      @frisbee = @brian.items.create(name: "Frisbee", description: "Fido and I love playing with this frisbee at the park.", price: 14, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      @user_2 = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon')


      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @user_2.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)
      order_3 = @user.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210)

      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)
      item_order_2 = order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 20, merchant: @brian)

      item_order_3 = order_2.item_orders.create!(item: @shifter, price: @shifter.price, quantity: 18, merchant: @meg)
      item_order_4 = order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 1, merchant: @meg)
      item_order_5 = order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2, merchant: @brian)

      item_order_6 = order_3.item_orders.create!(item: @dog_treats, price: @dog_treats.price, quantity: 15, merchant: @brian)
      item_order_7 = order_3.item_orders.create!(item: @frisbee, price: @frisbee.price, quantity: 5, merchant: @brian)


      expect(item_order_1.order.status).to eq('pending')
      expect(item_order_2.order.status).to eq('pending')
      expect(item_order_3.order.status).to eq('pending')
      expect(item_order_4.order.status).to eq('pending')
      expect(item_order_5.order.status).to eq('pending')

      item_order_1.fulfill
      item_order_2.fulfill
      item_order_3.fulfill

      order_1.reload
      order_2.reload
      order_1.item_orders.reload
      order_2.item_orders.reload


      expect(item_order_1.status).to eq('fulfilled')
      expect(item_order_2.status).to eq('fulfilled')
      expect(order_1.status).to eq('packaged')

      expect(item_order_3.status).to eq('fulfilled')
      expect(item_order_4.status).to eq('pending')
      expect(item_order_5.status).to eq('pending')
      expect(order_2.status).to eq('pending')
    end
  end
end
