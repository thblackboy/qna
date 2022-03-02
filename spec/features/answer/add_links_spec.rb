require 'rails_helper'

feature 'User can add links when makes answer', "
In order to add links which complete answer
As an authenticated user
I'd like to be able to add links when make answer
" do
    describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, author: user) }

    background do
      login(user)
      click_on 'Show'
    end

    scenario 'asks and adds links' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'google'
      fill_in 'Url', with: 'https://google.com'
      click_on 'Create answer'

      expect(page).to have_link 'google', href: 'https://google.com'
    end

    scenario 'asks and adds invalid links' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'google'
      click_on 'Create answer'

      expect(page).to have_content "Links url can't be blank"
    end
  end
end
