require 'rails_helper'

describe 'admin user profile page' do
  before(:each) do
    @admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz")
    @user_2 = User.create(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create(name: 'Sonny Moore', email: "its_always_sonny@gmail.com", password: "beatz")

    dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @merchant_employee = dog_shop.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 1)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    @merchant_admin = pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
    pull_toy = pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = @user_2.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)

    @order_1.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 2, merchant: dog_shop)
    @order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2, merchant: pawty_city)

    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'
  end
  it 'admin sees user profile with their information without link to edit profile' do

    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      click_link(@user_1.name)
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}")

    expect(page).to_not have_content("#{@user_1.name}'s Orders")
    expect(page).to have_content("E-mail: #{@user_1.email}")
    expect(page).to have_content("Role: #{@user_1.role.gsub('_', ' ').capitalize}")

  end
  it 'admin sees link to user orders if they have orders' do

    visit '/admin/users'

    within "#users-#{@user_2.id}" do
      click_link(@user_2.name)
    end

    expect(current_path).to eq("/admin/users/#{@user_2.id}")

    expect(page).to have_content("#{@user_2.name}'s Orders")
    expect(page).to have_content("E-mail: #{@user_2.email}")
    expect(page).to have_content("Role: #{@user_2.role.gsub('_', ' ').capitalize}")
  end
end
