require 'rails_helper'

describe 'admins can disable merchants from merchant index page' do
  before(:each) do
    @pawty_city = Merchant.create!(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    pull_toy = @pawty_city.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    banana = @pawty_city.items.create(name: "Banana Costume", description: "Don't let this costume slip by you!", price: 13.50, image: "https://i.imgur.com/Eg0lBXd.jpg", inventory: 7)
    shark = @pawty_city.items.create(name: "Baby Shark Costume", description: "Baby shark, doo doo doo doo doo doo doo... ", price: 23.75, image: "https://i.imgur.com/gzRbKT2.jpg", inventory: 2)
    harry_potter = @pawty_city.items.create(name: "Harry Potter Costume", description: "Look who got into Hogwarts.", price: 16.00, image: "https://i.imgur.com/GC4ppbA.jpg", inventory: 13)

    @a_latte_fun = Merchant.create(name: "A Latte Fun", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210", status: 'disabled')
    chai_latte = @a_latte_fun.items.create(name: "Chai Latte", description: "So yummy!", price: 4.50, image: "https://i.imgur.com/G5powzX.jpg", inventory: 10, active?: false )
    pumpkin_loaf = @a_latte_fun.items.create(name: "Pumpkin Spice Loaf", description: "Warm and tasty!", price: 5.00, image: "https://i.imgur.com/Q3dEKCn.jpg", inventory: 7, active?: false )
    apple_strudel = @a_latte_fun.items.create(name: "Apple Strudel", description: "Just as good as grandma's.", price: 6.00, image: "https://i.imgur.com/GJA1T0e.jpg", inventory: 3, active?: false )
    hot_coco = @a_latte_fun.items.create(name: "Hot Chocolate", description: "Delicious dark hot chocolate topped with whip cream.", price: 3.50, image: "https://i.imgur.com/cDI4mCQ.jpg", active?: false, inventory: 12)

    @suite_deal = Merchant.create(name: "Suite Deal Home Goods", address: '1280 Park Ave', city: 'Denver', state: 'CO', zip: "80202")
    @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203, status: 'disabled')
    @knit_wit = Merchant.create(name: "Knit Wit", address: '123 Main St.', city: 'Denver', state: 'CO', zip: "80218")

    admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)

    visit '/'
    click_link 'Login'
    fill_in :email, with: admin.email
    fill_in :password, with: admin.password
    click_button 'Log In'
  end
  it 'admin can click disable button for any merchant not disabled' do

    visit '/merchants'

    within "#merchant-#{@knit_wit.id}" do
      expect(page).to have_button('Disable')
    end

    within "#merchant-#{@pawty_city.id}" do
      expect(page).to have_button('Disable')
    end

    within "#merchant-#{@suite_deal.id}" do
      click_button 'Disable'
    end

    expect(current_path).to eq('/merchants')

    @suite_deal.reload
    expect(page).to have_content('Suite Deal Home Goods is now disabled.')
    expect(@suite_deal.status).to eq('disabled')
  end
  it 'when an admin disables merchant all merchant items become inactive' do
    visit '/merchants'

    @pawty_city.items.each do |item|
      expect(item.active?).to eq(true)
    end

    within "#merchant-#{@pawty_city.id}" do
      click_button 'Disable'
    end

    @pawty_city.reload
    expect(@pawty_city.status).to eq('disabled')


    @pawty_city.items.each do |item|
      expect(item.active?).to eq(false)
    end
  end
  it 'admin can click enable button for any merchant disabled' do
    visit '/merchants'

    within "#merchant-#{@a_latte_fun.id}" do
      expect(page).to have_button 'Enable'
    end

    within "#merchant-#{@dog_shop.id}" do
      click_button 'Enable'
    end

    @dog_shop.reload

    expect(@dog_shop.status).to eq('enabled')
  end
  it 'when admin enables merchant all merchant items become active' do
    visit '/merchants'

    @a_latte_fun.items.each do |item|
      expect(item.active?).to eq(false)
    end

    within "#merchant-#{@a_latte_fun.id}" do
      click_button 'Enable'
    end

    @a_latte_fun.reload

    expect(@a_latte_fun.status).to eq('enabled')

    @a_latte_fun.items.each do |item|
      expect(item.active?).to eq(true)
    end
  end
end
