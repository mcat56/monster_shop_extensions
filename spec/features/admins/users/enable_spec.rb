require 'rails_helper'

describe 'admin can disable a user account' do
  before(:each) do
    @admin = User.create!(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create!(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz", is_active: false)
    @user_2 = User.create!(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create!(name: 'Sonny Moore', email: "its_always_sonny@gmail.com", password: "beatz")
    @address_1 = @user_1.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')
    @address_2 = @user_2.addresses.create(nickname: 'work', street: '65 Work Street', city: 'Orangeburg', state: 'NY', zip: '10962')
    @address_3 = @user_3.addresses.create(nickname: 'parents', street: '2034 Nostalgia Place', city: 'Nyack', state: 'NY', zip: '10960')

    @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)


    @pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    @pull_toy = @pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = @user_1.orders.create!(name: 'Brian', address: @address_1)

    @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2, merchant: @dog_shop)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2, merchant: @pawty_city)

  end
  it 'disabled user cannot login' do

    visit '/'
    click_link 'Login'
    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_button 'Log In'

    expect(current_path).to eq('/login')
    expect(page).to have_content('Unable to login. Your account has been deactivated.')
  end
  it 'from user index page admin can click to enable users not disabled and see stats' do

    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'

    visit '/admin/users'

    within "#users-#{@user_3.id}" do
      expect(page).to have_link('Disable')
    end

    within "#users-#{@user_2.id}" do
      expect(page).to have_link('Disable')
    end

    within "#users-#{@user_1.id}" do
      click_link('Enable')
    end

    @user_1.reload
    expect(current_path).to eq('/admin/users')
    expect(page).to have_content("#{@user_1.name}'s account has been enabled.")

    expect(@user_2.is_active).to eq(true)

    click_link 'Log Out'

    click_link 'Login'

    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_button 'Log In'


    expect(current_path).to eq("/profile/#{@user_1.id}")
    expect(page).to have_content("Welcome, Richy Rich! You are logged in.")

    expect(@pawty_city.distinct_cities).to include('Honolulu')

    visit '/orders'

    expect(page).to_not have_css("#order-#{@order_1.id}")
  end
end
