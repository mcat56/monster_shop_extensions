require 'rails_helper'

describe 'As a Merchant User' do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    merchant_admin = @meg.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

    @order_1 = user.orders.create!(name: 'Meg', address: address_1) 

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, merchant: @meg)

    visit '/'
    click_link 'Login'
    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password
    click_button 'Log In'
    visit "/merchant/items"
  end

  it 'From merchant items page merchant I can delete items that have never been ordered' do

    within "#item-#{@tire.id}" do
      expect(page).to_not have_link('Delete Item')
    end

    within "#item-#{@chain.id}" do
      expect(page).to have_link('Delete Item')
    end

    within "#item-#{@shifter.id}" do
      click_link 'Delete Item'
    end

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content('Shimano Shifters has been deleted.')
    expect(page).to_not have_css("#items-#{@shifter.id}")
  end
end
