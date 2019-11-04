require 'rails_helper'

RSpec.describe "merchant dashboard" do
  describe "as an admin" do
    before(:each) do
      @admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)

      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @merchant_employee = @dog_shop.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 1)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
      @merchant_admin = @pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
      @pull_toy = @pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @banana = @pawty_city.items.create(name: "Banana Costume", description: "Don't let this costume slip by you!", price: 13.50, image: "https://i.imgur.com/Eg0lBXd.jpg", inventory: 7)
      @shark = @pawty_city.items.create(name: "Baby Shark Costume", description: "Baby shark, doo doo doo doo doo doo doo... ", price: 23.75, image: "https://i.imgur.com/gzRbKT2.jpg", inventory: 2)
      @harry_potter = @pawty_city.items.create(name: "Harry Potter Costume", description: "Look who got into Hogwarts.", price: 16.00, image: "https://i.imgur.com/GC4ppbA.jpg", inventory: 13)

      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      @address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      @order_1 = @user.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, address: @address_1)
      @order_2 = @user.orders.create!(name: 'Brian', street: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, address: @address_1)
      @order_3 = @user.orders.create!(name: 'Mike', street: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, address: @address_1)

      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, merchant: @pawty_city)
      @order_2.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2, merchant: @dog_shop)
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2, merchant: @pawty_city)
      @order_3.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 5, merchant: @dog_shop)

      visit '/'
      click_link 'Login'
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button 'Log In'
    end

    it 'displays name and address of the merchant that a merchant employee or merchant admin works for' do
      visit '/merchants'

      click_link "#{@dog_shop.name}"

      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}")
      expect(page).to have_content("Employer: #{@dog_shop.name}")
      expect(page).to have_content("Address: #{@dog_shop.address}")
      expect(page).to have_content("City: #{@dog_shop.city}")
      expect(page).to have_content("State: #{@dog_shop.state}")
      expect(page).to have_content("Zip Code: #{@dog_shop.zip}")

      visit '/merchants'

      click_link "#{@pawty_city.name}"

      expect(current_path).to eq("/admin/merchants/#{@pawty_city.id}")
      expect(page).to have_content("Employer: #{@pawty_city.name}")
      expect(page).to have_content("Address: #{@pawty_city.address}")
      expect(page).to have_content("City: #{@pawty_city.city}")
      expect(page).to have_content("State: #{@pawty_city.state}")
      expect(page).to have_content("Zip Code: #{@pawty_city.zip}")
    end

    it "I can see pending orders with a merchant's items" do
      visit '/merchants'

      click_link "#{@dog_shop.name}"

      within "#order-#{@order_2.id}" do
        expect(page).to have_link "#{@order_2.id}"
        expect(page).to have_content("Date of Order: #{@order_2.created_at.to_formatted_s(:long_ordinal)}")
        expect(page).to have_content("My Item Quantity: 2")
        expect(page).to have_content("My Total Value: $40.00")
      end

      within "#order-#{@order_3.id}" do
        expect(page).to have_link "#{@order_3.id}"
        expect(page).to have_content("Date of Order: #{@order_3.created_at.to_formatted_s(:long_ordinal)}")
        expect(page).to have_content("My Item Quantity: 5")
        expect(page).to have_content("My Total Value: $100.00")
      end
    end

    it "I can click a link to view a merchant's items" do
      visit '/merchants'

      click_link "#{@dog_shop.name}"

      click_link "View #{@dog_shop.name}'s Items"
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items")
    end
  end
end
