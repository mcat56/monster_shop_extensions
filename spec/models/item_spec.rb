require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    # it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end
    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')
      order = user.orders.create(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, address: address_1)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2, merchant: @bike_shop)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  describe "class methods" do
    it "top five items" do
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 20)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @squeaky_toy = @brian.items.create(name: "Squeaky Toy", description: "Awesome squeaky toy!", price: 15, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
      @dog_treats = @brian.items.create(name: "Dog Treats", description: "Pretty good dog treats. My dog liked them.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 25)

      @frisbee = @brian.items.create(name: "Frisbee", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @dog_bed = @brian.items.create(name: "Dog Bed", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @tennis_ball = @brian.items.create(name: "Tennis Ball", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @dog_shampoo = @brian.items.create(name: "Dog Shampoo", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)

      order_1 = @user.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, address: address_1)
      order_2 = @user.orders.create!(name: 'Brian', street: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, address: address_1)
      order_3 = @user.orders.create!(name: 'Mike', street: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, address: address_1)

      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)
      order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 20, merchant: @brian)
      order_2.item_orders.create!(item: @shifter, price: @shifter.price, quantity: 18, merchant: @meg)
      order_2.item_orders.create!(item: @squeaky_toy, price: @squeaky_toy.price, quantity: 19, merchant: @brian)
      order_3.item_orders.create!(item: @dog_treats, price: @dog_treats.price, quantity: 15, merchant: @brian)
      order_3.item_orders.create!(item: @frisbee, price: @frisbee.price, quantity: 5, merchant: @brian)
      order_3.item_orders.create!(item: @dog_bed, price: @dog_bed.price, quantity: 1, merchant: @brian)
      order_3.item_orders.create!(item: @tennis_ball, price: @tennis_ball.price, quantity: 2, merchant: @brian)
      order_3.item_orders.create!(item: @dog_shampoo, price: @dog_shampoo.price, quantity: 3, merchant: @brian)

      expect(Item.top_five_items.first).to eq(@pull_toy)
      expect(Item.top_five_items[1]).to eq(@squeaky_toy)
      expect(Item.top_five_items[2]).to eq(@shifter)
      expect(Item.top_five_items[3]).to eq(@dog_treats)
      expect(Item.top_five_items[4]).to eq(@tire)
    end

    it "bottom five items" do
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 20)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @squeaky_toy = @brian.items.create(name: "Squeaky Toy", description: "Awesome squeaky toy!", price: 15, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
      @dog_treats = @brian.items.create(name: "Dog Treats", description: "Pretty good dog treats. My dog liked them.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 25)

      @frisbee = @brian.items.create(name: "Frisbee", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @dog_bed = @brian.items.create(name: "Dog Bed", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @tennis_ball = @brian.items.create(name: "Tennis Ball", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @dog_shampoo = @brian.items.create(name: "Dog Shampoo", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)

      order_1 = @user.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, address: address_1) 
      order_2 = @user.orders.create!(name: 'Brian', street: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, address: address_1) 
      order_3 = @user.orders.create!(name: 'Mike', street: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, address: address_1) 

      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 10, merchant: @brian)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg )
      order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 20, merchant: @brian)
      order_2.item_orders.create!(item: @shifter, price: @shifter.price, quantity: 18, merchant: @meg )
      order_2.item_orders.create!(item: @squeaky_toy, price: @squeaky_toy.price, quantity: 20, merchant: @brian)
      order_3.item_orders.create!(item: @dog_treats, price: @dog_treats.price, quantity: 10, merchant: @brian)
      order_3.item_orders.create!(item: @frisbee, price: @frisbee.price, quantity: 5, merchant: @brian)
      order_3.item_orders.create!(item: @dog_bed, price: @dog_bed.price, quantity: 1, merchant: @brian)
      order_3.item_orders.create!(item: @tennis_ball, price: @tennis_ball.price, quantity: 2, merchant: @brian)
      order_3.item_orders.create!(item: @dog_shampoo, price: @dog_shampoo.price, quantity: 3, merchant: @brian)

      expect(Item.bottom_five_items.first).to eq(@dog_bed)
      expect(Item.bottom_five_items[1]).to eq(@tennis_ball)
      expect(Item.bottom_five_items[2]).to eq(@dog_shampoo)
      expect(Item.bottom_five_items[3]).to eq(@frisbee)
      expect(Item.bottom_five_items[4]).to eq(@dog_treats)
    end
  end
end
