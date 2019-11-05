require 'rails_helper'

describe 'merchant user can toggle a coupons status' do
  before(:each) do
    @pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    merchant_admin = @pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
    pull_toy = @pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @coupon_1 = @pawty_city.coupons.create(name: 'summer', percent: 0.2)
    @coupon_2 = @pawty_city.coupons.create!(name: 'winter', percent: 0.3)

    visit '/'

    click_link 'Login'

    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password
    click_button 'Log In'

    visit '/merchant/coupons'

  end
  it 'from show page can disable' do

    within "#coupon-#{@coupon_1.id}" do
      click_link "#{@coupon_1.name}"
    end

    expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}")

    click_link 'Disable'

    expect(current_path).to eq('/merchant/coupons')
    @coupon_1.reload

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content('Enabled?: false')
    end
  end
  it 'from show page can enable' do

    within "#coupon-#{@coupon_2.id}" do
      click_link "#{@coupon_2.name}"
    end

    expect(current_path).to eq("/merchant/coupons/#{@coupon_2.id}")

    click_link 'Disable'

    @coupon_2.reload

    within "#coupon-#{@coupon_2.id}" do
      click_link "#{@coupon_2.name}"
    end

    expect(current_path).to eq("/merchant/coupons/#{@coupon_2.id}")

    click_link 'Enable'

    @coupon_2.reload

    expect(current_path).to eq('/merchant/coupons')

    within "#coupon-#{@coupon_2.id}" do
      expect(page).to have_content('Enabled?: true')
    end
  end
end
