require 'rails_helper'


describe 'when I visit merchant dashboard' do
  before(:each) do
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

    user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')


    @order_1 = user.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @order_2 = user.orders.create!(name: 'Brian', street: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)
    @order_3 = user.orders.create!(name: 'Mike', street: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210)

    @order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, merchant: pawty_city)
    @order_2.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 2, merchant: dog_shop)
    @order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2, merchant: pawty_city)
    @order_3.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 5, merchant: dog_shop)
  end

  it 'displays name and address of the merchant I work for as an employee' do
    visit '/'
    click_link 'Login'

    fill_in :email, with: @merchant_employee.email
    fill_in :password, with: @merchant_employee.password
    click_button 'Log In'
    visit '/merchant'

    expect(page).to have_content("Employer: Meg's Dog Shop")
    expect(page).to have_content('Address: 123 Dog Rd.')
    expect(page).to have_content('City: Hershey')
    expect(page).to have_content('State: PA')
    expect(page).to have_content('Zip Code: 80203')
  end

  it 'displays name and address of the merchant I work for as an admin' do

    visit '/'
    click_link 'Login'

    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button 'Log In'

    visit '/merchant'

    expect(page).to have_content("Employer: Paw-ty City")
    expect(page).to have_content('Address: 123 Bike Rd.')
    expect(page).to have_content('City: Denver')
    expect(page).to have_content('State: CO')
    expect(page).to have_content('Zip Code: 80203')
  end

  it 'as a merchant employee I see pending orders with my items' do
    visit '/'
    click_link 'Login'

    fill_in :email, with: @merchant_employee.email
    fill_in :password, with: @merchant_employee.password
    click_button 'Log In'
    visit '/merchant'

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

  it "I can click a link to view my own items" do
    visit '/'
    click_link 'Login'

    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button 'Log In'

    visit '/merchant'

    click_link 'View My Items'
    expect(current_path).to eq('/merchant/items')
  end

  it 'as a merchant admin I see pending orders with my items' do
    visit '/'
    click_link 'Login'

    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button 'Log In'
    visit '/merchant'

    within "#order-#{@order_1.id}" do
      expect(page).to have_link "#{@order_1.id}"
      expect(page).to have_content("Date of Order: #{@order_1.created_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content("My Item Quantity: 3")
      expect(page).to have_content("My Total Value: $30.00")
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link "#{@order_2.id}"
      expect(page).to have_content("Date of Order: #{@order_2.created_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content("My Item Quantity: 2")
      expect(page).to have_content("My Total Value: $20.00")
    end
  end
end
