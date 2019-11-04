require 'rails_helper'

describe 'a merchant can create coupons' do
  before(:each) do
    pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    merchant_admin = pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
    pull_toy = pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    visit '/'

    click_link 'Login'

    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password
    click_button 'Log In'

    visit '/merchant'
  end
  it 'from dashboard merchant can add coupons' do

    within '#coupons' do
      click_link 'Manage Coupons'
    end

    expect(current_path).to eq('/merchant/coupons')
    click_link 'Add a Coupon'

    expect(current_path).to eq('/merchant/coupons/new')
    fill_in 'Name', with: 'SUMMER18'
    fill_in 'Percent', with: 0.2
    click_button 'Create Coupon'


    expect(page).to have_content('Your coupon has been created')
    expect(current_path).to eq('/merchant/coupons')
    coupon = Coupon.last

    expect(page).to have_css("#coupon-#{coupon.id}")
  end
  it 'cannot add coupon without filling out all fields' do
    within '#coupons' do
      click_link 'Manage Coupons'
    end

    expect(current_path).to eq('/merchant/coupons')
    click_link 'Add a Coupon'

    expect(current_path).to eq('/merchant/coupons/new')
    fill_in 'Name', with: ''
    fill_in 'Percent', with: ''
    click_button 'Create Coupon'

    expect(current_path).to eq('/merchant/coupons/new')
    expect(page).to have_content("Name can't be blank and Percent can't be blank")
  end 
end
