require 'rails_helper'

describe 'merchant order show page' do
  before(:each) do
    @user_1 = User.create(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz")
    @user_2 = User.create(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create(name: 'Sonny Moore', email: "its_always_sonny@gmail.com", password: "beatz")

    suite_deal= Merchant.create(name: "Suite Deal Home Goods", address: '1280 Park Ave', city: 'Denver', state: 'CO', zip: "80202")
    knit_wit = Merchant.create(name: "Knit Wit", address: '123 Main St.', city: 'Denver', state: 'CO', zip: "80218")

    a_latte_fun = Merchant.create(name: "A Latte Fun", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210")
    chai_latte = a_latte_fun.items.create(name: "Chai Latte", description: "So yummy!", price: 4.50, image: "https://i.imgur.com/G5powzX.jpg", inventory: 10)
    @pumpkin_loaf = a_latte_fun.items.create(name: "Pumpkin Spice Loaf", description: "Warm and tasty!", price: 5.00, image: "https://i.imgur.com/Q3dEKCn.jpg", inventory: 7)
    apple_strudel = a_latte_fun.items.create(name: "Apple Strudel", description: "Just as good as grandma's.", price: 6.00, image: "https://i.imgur.com/GJA1T0e.jpg", inventory: 3)
    hot_coco = a_latte_fun.items.create(name: "Hot Chocolate", description: "Delicious dark hot chocolate topped with whip cream.", price: 3.50, image: "https://i.imgur.com/cDI4mCQ.jpg", active?:false, inventory: 12)

    dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @merchant_employee = dog_shop.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 1)
    @dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    @merchant_admin = pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
    pull_toy = pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    banana = pawty_city.items.create(name: "Banana Costume", description: "Don't let this costume slip by you!", price: 13.50, image: "https://i.imgur.com/Eg0lBXd.jpg", inventory: 7)
    @shark = pawty_city.items.create(name: "Baby Shark Costume", description: "Baby shark, doo doo doo doo doo doo doo... ", price: 23.75, image: "https://i.imgur.com/gzRbKT2.jpg", inventory: 2)
    @harry_potter = pawty_city.items.create(name: "Harry Potter Costume", description: "Look who got into Hogwarts.", price: 16.00, image: "https://i.imgur.com/GC4ppbA.jpg", inventory: 13)

    @merchant_admin = pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)

    @order_1 = @user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'packaged')
    @order_2 = @user_2.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)
    @order_3 = @user_3.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 'shipped')
    @order_4 = @user_3.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210, status: 'cancelled')

    @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 3, merchant: dog_shop)
    @order_1.item_orders.create!(item: chai_latte, price: chai_latte.price, quantity: 3, merchant: a_latte_fun)

    @order_2.item_orders.create!(item: hot_coco, price: hot_coco.price, quantity: 2, merchant: a_latte_fun)
    @order_2.item_orders.create!(item: banana, price: banana.price, quantity: 2, merchant: pawty_city)

    @order_3.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 5, merchant: dog_shop)
    @order_3.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 5, merchant: pawty_city)

    @order_4.item_orders.create!(item: @pumpkin_loaf, price: @pumpkin_loaf.price, quantity: 5, merchant: a_latte_fun)
    @order_4.item_orders.create!(item: @shark, price: @shark.price, quantity: 5, merchant: pawty_city)
    @order_4.item_orders.create!(item: @harry_potter, price: @harry_potter.price, quantity: 3, merchant: pawty_city)
    @order_4.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 5, merchant: dog_shop)
  end
  it 'from dashboard merchant can view order customer and info for their merchants items' do
    visit '/'
    click_link 'Login'
    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button 'Log In'

    visit '/merchant'

    within "#order-#{@order_4.id}" do
      click_link "#{@order_4.id}"
    end

    expect(current_path).to eq("/merchant/orders/#{@order_4.id}")

    within '#customer-info' do
      expect(page).to have_content('Name: Sonny Moore')
    end

    expect(page).to_not have_css("#item-#{@dog_bone.id}")
    expect(page).to_not have_css("#item-#{@pumpkin_loaf.id}")

    within "#item-#{@shark.id}" do
      expect(page).to have_link('Baby Shark Costume')
      expect(page).to have_css("img[src*='#{@shark.image}']")
      expect(page).to have_content('Price: $23.75')
      expect(page).to have_content('Quantity Ordered: 5')
    end
    within "#item-#{@harry_potter.id}" do
      expect(page).to have_link('Harry Potter Costume')
      expect(page).to have_css("img[src*='#{@harry_potter.image}']")
      expect(page).to have_content('Price: $16.00')
      expect(page).to have_content('Quantity Ordered: 3')
    end
  end
end
