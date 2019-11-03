RSpec.describe("New Order Page") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      visit '/'
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      @user_2 = User.create(name: 'Marcel', email: 'monkey34@gmail.com', password: 'bananas')
      address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'

    end
    it "I see all the information about my current cart" do
      visit "/cart"

      click_on "Checkout with Existing Address"

      within "#order-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#order-item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#order-item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      expect(page).to have_content("Total: $142")
    end

    it "I see a form where I can select my shipping info" do
      visit "/cart"
      click_on "Checkout with Existing Address"

      select('Home: 953 Sunshine Ave Honolulu Hawaii 96701', from: 'address')

      click_button "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/profile/orders/#{new_order.id}")
      expect(page).to have_link('Cart: 0')
      expect(page).to have_content('Your order has been placed!')
    end
    it 'I cant create order without an address' do
      click_link 'Log Out'
      click_link 'Login'
      fill_in :email, with: @user_2.email
      fill_in :password, with: @user_2.password
      click_button 'Log In'

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      visit "/cart"

      expect(page).to have_content('You cannot checkout without an existing address. Click link to Add Address')

      click_link('Add Address')

      expect(current_path).to eq("/users/#{@user_2.id}/addresses/new")
    end
  end
end
