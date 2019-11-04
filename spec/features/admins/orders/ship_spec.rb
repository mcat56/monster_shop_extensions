require 'rails_helper'


describe 'ship order' do
  it 'admin can ship an order' do
    @admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz")
    @address_1 = @user_1.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

    pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    pull_toy = pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = @user_1.orders.create!(name: 'Meg', status: 'packaged', address: @address_1) 
    @order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3, merchant: pawty_city)

    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'


    within "#packaged" do
      within "#orders-#{@order_1.id}" do
        click_link 'Ship Order'
      end
    end

    @order_1.reload

    within "#packaged" do
      expect(page).to_not have_css("#orders-#{@order_1.id}")
    end

    within "#shipped" do
      expect(page).to have_css("#orders-#{@order_1.id}")
      expect(@order_1.status).to eq('shipped')
    end

    click_link 'Log Out'
    click_link 'Login'
    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_button 'Log In'

    visit "/profile/orders/#{@order_1.id}"

    expect(@order_1.status).to eq('shipped')
    expect(page).to_not have_link('Cancel Order')
  end
end
