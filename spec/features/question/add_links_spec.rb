require 'rails_helper'

feature 'User can add links when asks question', "
In order to add links which complete question description
As an authenticated user
I'd like to be able to add links when ask question
" do
    describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      login(user)
      click_on 'Ask question'
    end

    scenario 'asks and adds links' do
      fill_in 'Title',	with: 'Question title'
      fill_in 'Body',	with: 'Question body'
      fill_in 'Link name', with: 'google'
      fill_in 'Url', with: 'https://google.com'
      click_on 'Ask'

      expect(page).to have_link 'google', href: 'https://google.com'
    end
  end

  scenario 'Unauthenticated uset tries to ask question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end