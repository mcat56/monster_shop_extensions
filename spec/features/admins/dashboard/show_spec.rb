require 'rails_helper'

RSpec.describe "admin dashboard" do
  before(:each) do
    @admin = User.create(name: 'Monica',  email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz")
    @user_2 = User.create(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create(name: 'Sonny Moore', email: "its_always_sonny@gmail.com", password: "beatz")

    suite_deal= Merchant.create(name: "Suite Deal Home Goods", address: '1280 Park Ave', city: 'Denver', state: 'CO', zip: "80202")
    knit_wit = Merchant.create(name: "Knit Wit", address: '123 Main St.', city: 'Denver', state: 'CO', zip: "80218")
    a_latte_fun = Merchant.create(name: "A Latte Fun", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210")

    dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @merchant_employee = dog_shop.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 1)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    @merchant_admin = pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
    pull_toy = pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    banana = pawty_city.items.create(name: "Banana Costume", description: "Don't let this costume slip by you!", price: 13.50, image: "https://i.imgur.com/Eg0lBXd.jpg", inventory: 7)
    shark = pawty_city.items.create(name: "Baby Shark Costume", description: "Baby shark, doo doo doo doo doo doo doo... ", price: 23.75, image: "https://i.imgur.com/gzRbKT2.jpg", inventory: 2)
    harry_potter = pawty_city.items.create(name: "Harry Potter Costume", description: "Look who got into Hogwarts.", price: 16.00, image: "https://i.imgur.com/GC4ppbA.jpg", inventory: 13)



    @order_1 = @user_1.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'packaged')
    @order_2 = @user_2.orders.create!(name: 'Brian', street: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)
    @order_3 = @user_3.orders.create!(name: 'Mike', street: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 'shipped')
    @order_4 = @user_3.orders.create!(name: 'Mike', street: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 'cancelled')

    @order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, merchant: pawty_city)
    @order_2.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 2, merchant: dog_shop)
    @order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2, merchant: pawty_city)
    @order_3.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 5, merchant: dog_shop)
    @order_4.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 5, merchant: dog_shop)
    @order_4.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 5, merchant: pawty_city)
    @order_4.item_orders.create!(item: harry_potter, price: harry_potter.price, quantity: 5, merchant: pawty_city)

    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'
  end

  it "I can see all default users with their info and perform the following actions:
   - edit user profile
   - edit user password
   - upgrade a user to a merchant account" do

   visit '/admin/users'

   within "#users-#{@user_1.id}" do
    expect(page).to have_content(@user_1.name)
    expect(page).to have_content(@user_1.email)
    expect(page).to have_link("Edit Profile")
    expect(page).to have_link("Edit Password")
    expect(page).to have_link("Upgrade to Merchant User")

    click_link "Edit Profile"
    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit")
   end

   visit '/admin/users'

   within "#users-#{@user_1.id}" do
    click_link "Edit Password"
    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit/password")
   end

   visit '/admin/users'

   within "#users-#{@user_2.id}" do
    expect(page).to have_content(@user_2.name)
    expect(page).to have_content(@user_2.email)
    expect(page).to have_link("Edit Profile")
    expect(page).to have_link("Edit Password")
    expect(page).to have_link("Upgrade to Merchant User")

    click_link "Edit Profile"
    expect(current_path).to eq("/admin/users/#{@user_2.id}/edit")
   end

   visit '/admin/users'

   within "#users-#{@user_2.id}" do
    click_link "Edit Password"
    expect(current_path).to eq("/admin/users/#{@user_2.id}/edit/password")
   end

   visit '/admin/users'

   within "#users-#{@user_3.id}" do
    expect(page).to have_content(@user_3.name)
    expect(page).to have_content(@user_3.email)
    expect(page).to have_link("Edit Profile")
    expect(page).to have_link("Edit Password")
    expect(page).to have_link("Upgrade to Merchant User")

    click_link "Edit Profile"
    expect(current_path).to eq("/admin/users/#{@user_3.id}/edit")
   end

   visit '/admin/users'

   within "#users-#{@user_3.id}" do
    click_link "Edit Password"
    expect(current_path).to eq("/admin/users/#{@user_3.id}/edit/password")
   end
 end

  it "can upgrade default user to merchant user" do
    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      click_link "Upgrade to Merchant User"
      expect(current_path).to eq("/admin/users/#{@user_1.id}/edit_role")
    end

    visit '/admin/users'

    within "#users-#{@user_2.id}" do
      click_link "Upgrade to Merchant User"
      expect(current_path).to eq("/admin/users/#{@user_2.id}/edit_role")
    end

    visit '/admin/users'

    within "#users-#{@user_3.id}" do
     click_link "Upgrade to Merchant User"
     expect(current_path).to eq("/admin/users/#{@user_3.id}/edit_role")
    end
  end

  it 'displays all orders and the order information' do

    within "#packaged" do
      expect(page).to have_content('Packaged:')
      within "#orders-#{@order_1.id}" do
        expect(page).to have_content("Placed by: #{@user_1.name}")
        expect(page).to have_content("Order ID: #{@order_1.id}")
        expect(page).to have_content("Creation Date: #{@order_1.created_at.to_formatted_s(:long_ordinal)}")
      end
    end

    within "#pending" do
      expect(page).to have_content('Pending:')
      within "#orders-#{@order_2.id}" do
        expect(page).to have_content("Placed by: #{@user_2.name}")
        expect(page).to have_content("Order ID: #{@order_2.id}")
        expect(page).to have_content("Creation Date: #{@order_2.created_at.to_formatted_s(:long_ordinal)}")
      end
    end

    within "#shipped" do
      expect(page).to have_content('Shipped:')
      within "#orders-#{@order_3.id}" do
        expect(page).to have_content("Placed by: #{@user_3.name}")
        expect(page).to have_content("Order ID: #{@order_3.id}")
        expect(page).to have_content("Creation Date: #{@order_3.created_at.to_formatted_s(:long_ordinal)}")
      end
    end

    within "#cancelled" do
      expect(page).to have_content('Cancelled:')
      within "#orders-#{@order_4.id}" do
        expect(page).to have_content("Placed by: #{@user_3.name}")
        expect(page).to have_content("Order ID: #{@order_4.id}")
        expect(page).to have_content("Creation Date: #{@order_4.created_at.to_formatted_s(:long_ordinal)}")
      end
    end

    within "#packaged" do
      within "#orders-#{@order_1.id}" do
        click_link "#{@user_1.name}"
        expect(current_path).to eq("/admin/users/#{@user_1.id}")
      end
    end


    visit '/admin'

    within "#pending" do
      within "#orders-#{@order_2.id}" do
        click_link "#{@user_2.name}"
        expect(current_path).to eq("/admin/users/#{@user_2.id}")
      end
    end

    visit '/admin'

    within "#shipped" do
      within "#orders-#{@order_3.id}" do
        click_link "#{@user_3.name}"
        expect(current_path).to eq("/admin/users/#{@user_3.id}")
      end
    end

    visit '/admin'

    within "#cancelled" do
      within "#orders-#{@order_4.id}" do
        click_link "#{@user_3.name}"
        expect(current_path).to eq("/admin/users/#{@user_3.id}")
      end
    end
  end
end
