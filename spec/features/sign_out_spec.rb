require 'rails_helper'

feature 'User can finish session', "
In order to sign out
As an authentificated user
I'd like to be able to logout
" do
  given(:user) { create(:user) }
  scenario 'Authenticated user tries to sign out' do
    login(user)
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully'
  end

  scenario 'Unauthenticated user tries to sign out' do
    visit questions_path
    expect(page).to_not have_content 'Logout'
  end
end
