require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 20)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @squeaky_toy = @brian.items.create(name: "Squeaky Toy", description: "Awesome squeaky toy!", price: 15, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
      @dog_treats = @brian.items.create(name: "Dog Treats", description: "Pretty good dog treats. My dog liked them.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 25)

      @frisbee = @brian.items.create(name: "Frisbee", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @dog_bed = @brian.items.create(name: "Dog Bed", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @tennis_ball = @brian.items.create(name: "Tennis Ball", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
      @dog_shampoo = @brian.items.create(name: "Dog Shampoo", description: "Fido and I love playing with this frisbee at the park.", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)

      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "I see all items in the system except disabled items" do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "I can see an area with statistics that displays top 5 most popular items and bottom 5 least popular items" do
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      @address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      order_1 = @user.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, address: @address_1) 
      order_2 = @user.orders.create!(name: 'Brian', street: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, address: @address_1) 
      order_3 = @user.orders.create!(name: 'Mike', street: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, address: @address_1) 

      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg )
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg )
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg )
      order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 20, merchant: @brian )
      order_2.item_orders.create!(item: @shifter, price: @shifter.price, quantity: 18, merchant: @meg )
      order_2.item_orders.create!(item: @squeaky_toy, price: @squeaky_toy.price, quantity: 19, merchant: @brian )
      order_3.item_orders.create!(item: @dog_treats, price: @dog_treats.price, quantity: 15, merchant: @brian )
      order_3.item_orders.create!(item: @frisbee, price: @frisbee.price, quantity: 5, merchant: @brian )
      order_3.item_orders.create!(item: @dog_bed, price: @dog_bed.price, quantity: 1, merchant: @brian )
      order_3.item_orders.create!(item: @tennis_ball, price: @tennis_ball.price, quantity: 2, merchant: @brian )
      order_3.item_orders.create!(item: @dog_shampoo, price: @dog_shampoo.price, quantity: 3, merchant: @brian )

      visit '/items'

      within ".item-stats" do
        within ".top-five-items" do
          expect(page).to have_content(@pull_toy.name)
          expect(page).to have_content("Quantity bought: 20")

          expect(page).to have_content(@squeaky_toy.name)
          expect(page).to have_content("Quantity bought: 19")

          expect(page).to have_content(@shifter.name)
          expect(page).to have_content("Quantity bought: 18")

          expect(page).to have_content(@dog_treats.name)
          expect(page).to have_content("Quantity bought: 15")

          expect(page).to have_content(@tire.name)
          expect(page).to have_content("Quantity bought: 6")

          expect(page).to_not have_content(@frisbee.name)
        end

        within ".bottom-five-items" do
          expect(page).to have_content(@frisbee.name)
          expect(page).to have_content("Quantity bought: 5")

          expect(page).to have_content(@dog_bed.name)
          expect(page).to have_content("Quantity bought: 1")
          expect(page).to have_content(@tennis_ball.name)
          expect(page).to have_content("Quantity bought: 2")
          expect(page).to have_content(@dog_shampoo.name)
          expect(page).to have_content("Quantity bought: 3")
          expect(page).to have_content(@tire.name)
          expect(page).to have_content("Quantity bought: 6")
          expect(page).to_not have_content(@shifter.name)
        end
      end
    end

    it "I can access each item's show page by clicking on the item's image on the items index page" do

      visit '/items'

      within "#item-#{@tire.id}" do
        click_link "image-#{@tire.id}"
      end
      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'

      within "#item-#{@pull_toy.id}" do
        click_link "image-#{@pull_toy.id}"
      end
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end
  end
end
