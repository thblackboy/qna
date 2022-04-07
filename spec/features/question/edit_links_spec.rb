require 'rails_helper'

feature 'User can edit links when asks question', "
In order to edit links which are incorrect
As an author of question
I'd like to be able to edit links when ask question
" do
    describe 'Author', js: true do
    given(:user) { create(:user) }

    background do
      login(user)
      click_on 'Ask question'
      fill_in 'Title',	with: 'Question title'
      fill_in 'Body',	with: 'Question body'
      fill_in 'Link name', with: 'google'
      fill_in 'Url', with: 'https://google.com'
      click_on 'Ask'
      visit questions_path
      click_on 'Edit'
    end

    scenario 'edits links' do
      fill_in 'Link name', with: 'lolo2'
      click_on 'Save'
      click_on 'Show'
      expect(page).to_not have_link 'google'
      expect(page).to have_link 'lolo2'
    end

    scenario 'edits links with invalid attributes' do
      fill_in 'Link name', with: ''
      click_on 'Save'

      expect(page).to have_content "Links name can't be blank"
    end
  end
end
