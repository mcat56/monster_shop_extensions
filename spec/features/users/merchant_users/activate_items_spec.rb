require 'rails_helper'

describe 'merchants can activate and deactivate items' do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    merchant_admin = @meg.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    visit '/'
    click_link 'Login'

    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password
    click_button 'Log In'
    visit "/merchant/items"
  end
  it 'merchant can deactivate item from merchant item index' do

    within "#item-#{@shifter.id}" do
      expect(page).to have_link 'Activate'
    end

    within "#item-#{@tire.id}" do
      expect(page).to have_link 'Deactivate'
    end


    within "#item-#{@chain.id}" do
      click_link 'Deactivate'
    end
    @chain.reload
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("Chain is no longer for sale.")

    expect(@chain.active?).to eq(false)
  end
  it 'merchant can activate item from merchant item index' do

    expect(@shifter.active?).to eq(false)

    within "#item-#{@shifter.id}" do
      click_link 'Activate'
    end

    @shifter.reload
    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content('Shimano Shifters is now available for sale.')

    expect(@shifter.active?).to eq(true)
  end
end
