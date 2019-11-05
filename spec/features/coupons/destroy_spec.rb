require 'rails_helper'

describe 'merchant user can delete a coupon' do
  before(:each) do
    @pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    merchant_admin = @pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
    pull_toy = @pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @coupon_1 = @pawty_city.coupons.create!(name: 'summer', percent: 0.2)
    @coupon_2 = @pawty_city.coupons.create!(name: 'winter', percent: 0.1)

    visit '/'

    click_link 'Login'

    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password
    click_button 'Log In'

    visit '/merchant/coupons'
  end
  it 'clicks link delete from show page' do

    within "#coupon-#{@coupon_1.id}" do
      click_link "#{@coupon_1.name}"
    end

    click_link 'Delete Coupon'

    expect(page).to have_content('Coupon Deleted')
    expect(current_path).to eq('/merchant/coupons')
    expect(page).to_not have_css("#coupon-#{@coupon_1.id}")
  end
  it 'cannot delete coupon that has been used' do
    user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

    user.orders.create(name: 'Patti', address: address_1, coupon: @coupon_2)

    visit "/merchant/coupons/#{@coupon_2.id}"

    expect(page).to_not have_link('Delete Coupon')
  end

end
