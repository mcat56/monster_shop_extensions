require 'rails_helper'

describe 'user can delete addresses' do
  before(:each) do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    merchant_employee = mike.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 1)
    admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)


    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    @address_1 = @user.addresses.create(street: '234 Orange Ave', city: 'Orangeburg', state: 'NY', zip: '10962')
    @address_2 = @user.addresses.create(nickname: 'work', street: '65 Work Street', city: 'Houston', state: 'TX', zip: '77001')
    @address_3 = @user.addresses.create(nickname: 'parents', street: '2034 Nostalgia Place', city: 'Nyack', state: 'NY', zip: '10960')
    visit '/'
    click_link 'Login'
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'

    order_1 = @user.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'pending', address: @address_3 )
    order_2 = @user.orders.create!(name: 'Meg', street: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 'shipped', address: @address_2)

    visit "/profile/#{@user.id}"
    click_link 'My Addresses'

  end
  it 'links from address show' do

    within "#address-#{@address_1.id}" do
      click_link "#{@address_1.nickname}"
    end

    click_link 'Delete Address'

    expect(current_path).to eq("/profile/#{@user.id}")
    expect(page).to have_content('Address deleted')
    expect(page).to_not have_css("#address-#{@address_1.id}")
  end
  it 'user cannot delete an address if there is a shipped order with that address' do

    within "#address-#{@address_2.id}" do
      click_link "#{@address_2.nickname}"
    end

    expect(page).to_not have_link('Delete Address')
    expect(page).to have_content('Address cannot be updated or deleted while shipped orders in progress')
  end
  it 'user can delete an address if there is a pending order with that address' do

    within "#address-#{@address_3.id}" do
      click_link "#{@address_3.nickname}"
    end

    click_link 'Delete Address'

    # click_link 'Update with New Address'
    #
    # fill_in :name, with: 'Patti'
    # fill_in :street, with: '957 Portland Ave'
    # fill_in :city, with: 'Portland'
    # fill_in :state, with: 'ME'
    # fill_in :zip, with: '04019'
    # click_button 'Update Order'


    expect(current_path).to eq("/profile/orders")
    expect(page).to have_content('You must update pending orders before deleting this address')
  end
end
