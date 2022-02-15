require 'rails_helper'

feature 'User can sign up', "
In order to ask question
As an unauthenticated and unregistered user
I'd like to be able to sign up
" do
  background { visit new_user_registration_path }
  scenario 'Register with valid attributes' do
    fill_in 'Email', with: 'tester@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'
  end

  scenario 'Register with invalid attributes' do
    fill_in 'Email', with: 'testertest.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '1234567'
    click_on 'Sign up'
    
    expect(page).to have_content 'Email is invalid'
    expect(page).to have_content "Password confirmation doesn't match"
  end
end
