require 'rails_helper'

describe 'admin can disable a user account' do
  before(:each) do
    @admin = User.create!(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create!(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz", is_active: false)
    @user_2 = User.create!(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create!(name: 'Sonny Moore',  email: "its_always_sonny@gmail.com", password: "beatz")

    @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)


    @pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    @pull_toy = @pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = @user_1.orders.create!(name: 'Brian', street: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)

    @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 2, merchant: @dog_shop)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2, merchant: @pawty_city)

  end
  it 'enabled user can login' do
    visit '/'
    click_link 'Login'
    fill_in :email, with: @user_2.email
    fill_in :password, with: @user_2.password
    click_button 'Log In'

    expect(current_path).to eq("/profile/#{@user_2.id}")
    expect(page).to have_content('Welcome, Alice Wonder! You are logged in.')
  end
  it 'from user index page admin can click to disable users not disabled' do
    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'

    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      expect(page).to have_link('Enable')
    end

    within "#users-#{@user_3.id}" do
      expect(page).to have_link('Disable')
    end

    within "#users-#{@user_2.id}" do
      click_link 'Disable'
    end

    @user_2.reload
    expect(current_path).to eq('/admin/users')
    expect(page).to have_content("#{@user_2.name}'s account has been disabled.")

    expect(@user_2.is_active).to eq(false)

    click_link 'Log Out'

    click_link 'Login'

    fill_in :email, with: @user_2.email
    fill_in :password, with: @user_2.password
    click_button 'Log In'


    expect(current_path).to eq('/login')
    expect(page).to have_content('Unable to login. Your account has been deactivated')
  end
  it 'disabled user info is not in stats' do

    expect(@dog_shop.distinct_cities).to_not include('Denver')

    visit '/orders'

    expect(page).to_not have_css("#order-#{@order_1.id}")
  end

end
