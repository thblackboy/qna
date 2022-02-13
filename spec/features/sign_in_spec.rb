require 'rails_helper'

feature 'User can sign in', "
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign in
" do
  scenario 'Registered user tries to sign in' do
    User.create!(email: 'test1@test.com', password: '123456')

    visit new_user_session_path

    fill_in 'Email',	with: 'test1@test.com'
    fill_in 'Password', with: '123456'

    click_on 'Log in'

    expect(page).to have_content 'Signed in successful'
  end

  scenario 'Unregistered user tries to sign in'
end
