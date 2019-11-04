require 'rails_helper'

describe 'merchant can edit their coupons' do
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
 it 'can edit from index page' do

    within "#coupon-#{@coupon_1.id}" do
      click_link 'Edit Coupon'
    end

  expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}/edit")

  expect(find_field('Name').value).to eq "summer"
  expect(find_field('Percent').value).to eq '0.2'

  fill_in 'Name', with: 'fall'
  fill_in 'Percent', with: 0.4
  click_button 'Update Coupon'

  expect(page).to have_content('Your coupon has been updated')
  expect(current_path).to eq('/merchant/coupons')

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content('Name: fall')
      expect(page).to have_content('Percent: 0.4')
    end
  end
  it 'cannot edit without filling out all fields' do
    within "#coupon-#{@coupon_2.id}" do
      click_link 'Edit Coupon'
    end

    fill_in 'Name', with: ''
    fill_in 'Percent', with: ''
    click_button 'Update Coupon'

    expect(current_path).to eq("/merchant/coupons/#{@coupon_2.id}/edit")
    expect(page).to have_content("Name can't be blank and Percent can't be blank")
  end
end
