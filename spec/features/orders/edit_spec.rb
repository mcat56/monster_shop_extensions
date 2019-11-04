require 'rails_helper'

describe 'a user can edit an order' do
  before(:each) do
    visit '/'
    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    @address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')
    @address_2 = @user.addresses.create(nickname: 'work', street: '65 Work Street', city: 'Orangeburg', state: 'NY', zip: '10962')
    @user_2 = User.create(name: 'Marcel', email: 'monkey34@gmail.com', password: 'bananas')
    @address_3 = @user_2.addresses.create(nickname: 'parents', street: '2034 Nostalgia Place', city: 'Nyack', state: 'NY', zip: '10960')

    click_link 'Login'

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50.00, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 25.05, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    shifter = bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 50.00, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 4)


    @order_1 = @user.orders.create!(name: 'Richy Rich', street: '102 Main St', city: 'NY', state: 'New York', zip: '10221', address: @address_1)
    @order_2 = @user_2.orders.create!(name: 'Alice Wonder', street: '346 Underground Blvd', city: 'NY', state: 'New York', zip: '10221', address: @address_3)
    order_3 = @user.orders.create!(name: 'Sonny Moore', street: '87 Electric Ave', city: 'NY', state: 'New York', zip: '10221', address: @address_2) 

    visit "/profile/orders/#{@order_1.id}"
  end
  it 'user can update with new address' do
    click_link 'Update with Existing Address'

    select('Work: 65 Work Street Orangeburg NY 10962', from: 'address')
    click_button 'Update Order'

    @order_1.reload

    expect(current_path).to eq('/profile/orders')
    expect(page).to have_content('Order information updated')
    expect(@order_1.name).to eq('Patti')
    expect(@order_1.street).to eq('65 Work Street')
    expect(@order_1.city).to eq('Orangeburg')
    expect(@order_1.state).to eq('NY')
    expect(@order_1.zip).to eq('10962')
  end
end
