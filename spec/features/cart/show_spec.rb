require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @coupon_1 = @meg.coupons.create(name: 'SUMMER18', percent: 0.25, enabled?: true)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper, @tire, @pencil]
      end
      it 'will display discounted total if coupon applied' do
        @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
        address_1 = @user.addresses.create(street: '234 Orange Ave', city: 'Orangeburg', state: 'NY', zip: '10962')

        visit '/'
        click_link 'Login'
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        click_button 'Log In'
        visit '/cart'

        fill_in :apply_coupon, with: 'SUMMER18'
        click_button 'Apply'

        expect(page).to have_content('Discounted Total: $97.00')

        click_link 'Checkout with Existing Address'


      end
      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end
      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end
      it 'after logging in I do not see a reminder to log in/register to check out' do
        visit '/cart'

        expect(page).to have_content('You must login or register to check out.')

        user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
        click_link 'Login'

        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_button 'Log In'

        visit '/cart'

        expect(page).to_not have_content('You must login or register to check out.')
      end
    end
  end
  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end
end
