require 'rails_helper'

RSpec.describe "As a registered user", type: :feature do
  before :each do
    @user = create(:user)
    login_as(@user)
    @order_1 = create(:order, user: @user, status: 'pending')
  end

  context "when it visits a pending order's show page" do
    it 'sees a button to cancel the order' do
      visit profile_order_path(@order_1)

      expect(page).to have_button("Cancel Order")
    end
  end

end
