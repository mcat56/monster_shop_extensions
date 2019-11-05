require 'rails_helper'

describe 'merchant can see all their coupons' do
  it 'from merchant dashboard they link to coupon index' do
    @pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    merchant_admin = @pawty_city.users.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 2)
    pull_toy = @pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    coupon_1 = @pawty_city.coupons.create(name: 'summer', percent: 0.2)
    coupon_2 = @pawty_city.coupons.create(name: 'winter', percent: 0.1)
    coupon_3 = @pawty_city.coupons.create(name: 'spring', percent: 0.15)
    coupon_4 = @pawty_city.coupons.create(name: 'fall', percent: 0.3)
    coupon_5 = @pawty_city.coupons.create(name: 'bogo', percent: 0.25)

    visit '/'

    click_link 'Login'

    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password
    click_button 'Log In'

    visit '/merchant/coupons'

    within "#coupon-#{coupon_1.id}" do
      expect(page).to have_content('Name: summer')
      expect(page).to have_content('Percent: 0.2')
    end

    within "#coupon-#{coupon_2.id}" do
      expect(page).to have_content('Name: winter')
      expect(page).to have_content('Percent: 0.1')
    end

    within "#coupon-#{coupon_3.id}" do
      expect(page).to have_content('Name: spring')
      expect(page).to have_content('Percent: 0.15')
    end

    within "#coupon-#{coupon_4.id}" do
      expect(page).to have_content('Name: fall')
      expect(page).to have_content('Percent: 0.3')
    end

    within "#coupon-#{coupon_5.id}" do
      expect(page).to have_content('Name: bogo')
      expect(page).to have_content('Percent: 0.25')
    end
  end
end
