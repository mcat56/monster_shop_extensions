require 'rails_helper'

describe 'merchant fulfills part of an order' do
  it 'from order show page can click items not yet fulfilled to fulfill if quantity <= inventory' do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 20)

    pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 12, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_treats = brian.items.create(name: "Dog Treats", description: "Pretty good dog treats. My dog liked them.", price: 11, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 25)
    frisbee = brian.items.create(name: "Frisbee", description: "Fido and I love playing with this frisbee at the park.", price: 14, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 28)
    dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    user = User.create(name: 'Patti', address: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701', email: 'pattimonkey34@gmail.com', password: 'banana')
    user_2 = User.create(name: 'Monica', address: '75 Chef Ave', city: 'Utica', state: 'New York', zip: '45827', email: 'cleaner@gmail.com', password: 'monmon')

    merchant_employee = brian.users.create(name: 'Ross', address: '56 HairGel Ave', city: 'Las Vegas', state: 'Nevada', zip: '65041', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 1)

    order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    order_2 = user_2.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)
    order_3 = user.orders.create!(name: 'Mike', address: '123 Dao St', city: 'Denver', state: 'CO', zip: 80210)

    item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, merchant: meg)
    item_order_2 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 20, merchant: brian)
    item_order_3 = order_1.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 40, merchant: brian)

    item_order_4 = order_2.item_orders.create!(item: shifter, price: shifter.price, quantity: 18, merchant: meg)
    item_order_5 = order_2.item_orders.create!(item: tire, price: tire.price, quantity: 1, merchant: meg)
    item_order_6 = order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2, merchant: brian)

    item_order_7 = order_3.item_orders.create!(item: dog_treats, price: dog_treats.price, quantity: 15, merchant: brian)
    item_order_8 = order_3.item_orders.create!(item: frisbee, price: frisbee.price, quantity: 5, merchant: brian)

    visit '/'
    click_link 'Login'
    fill_in :email, with: merchant_employee.email
    fill_in :password, with: merchant_employee.password
    click_button 'Log In'

    expect(item_order_1.order.status).to eq('pending')
    expect(item_order_2.order.status).to eq('pending')
    expect(item_order_6.order.status).to eq('pending')
    expect(item_order_7.order.status).to eq('pending')

    visit "/merchant/orders/#{order_1.id}"

    expect(page).to_not have_css("#item-#{tire.id}")


    within "#item-#{item_order_3.item.id}" do
      expect(page).to_not have_link('Fulfill')
      expect(page).to have_content('Item cannot be fulfilled due to lack of inventory.')
    end

    within "#item-#{item_order_2.item.id}" do
      click_link 'Fulfill'
    end

    within "#item-#{item_order_2.item.id}" do
      expect(page).to_not have_link('Fulfill')
      expect(page).to have_content('Item already fulfilled.')
    end

    expect(current_path).to eq("/merchant/orders/#{order_1.id}")
    expect(page).to have_content('Pull Toy has been fulfilled.')

    visit "/merchant/orders/#{order_3.id}"

    within "#item-#{dog_treats.id}" do
      click_link 'Fulfill'
    end

    expect(current_path).to eq("/merchant/orders/#{order_3.id}")
    expect(page).to have_content('Dog Treats has been fulfilled.')

    within "#item-#{frisbee.id}" do
      click_link 'Fulfill'
    end

    expect(current_path).to eq("/merchant/orders/#{order_3.id}")
    expect(page).to have_content('Frisbee has been fulfilled.')


    order_1.reload
    order_3.reload
    item_order_2.reload
    item_order_7.reload
    item_order_8.reload
    tire.reload
    shifter.reload
    pull_toy.reload
    dog_treats.reload
    frisbee.reload
    dog_bone.reload

    expect(tire.inventory).to eq(12)
    expect(shifter.inventory).to eq(20)

    expect(pull_toy.inventory).to eq(12)
    expect(dog_treats.inventory).to eq(10)

    expect(frisbee.inventory).to eq(23)
    expect(dog_bone.inventory).to eq(21)

    expect(item_order_1.status).to eq('pending')
    expect(item_order_2.status).to eq('fulfilled')
    expect(item_order_3.status).to eq('pending')
    expect(order_1.status).to eq('pending')

    expect(item_order_7.status).to eq('fulfilled')
    expect(item_order_8.status).to eq('fulfilled')
    expect(order_3.status).to eq('packaged')
  end
end
