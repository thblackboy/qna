require 'rails_helper'

feature 'User can remove links when asks question', "
In order to remove links which are useless
As an author of question
I'd like to be able to remove links when ask question
" do
  # describe 'Author', js: true do
  #   given(:user) { create(:user) }
  #   scenario 'remove links' do
  #     login(user)
  #     click_on 'Ask question'
  #     fill_in 'Title',	with: 'Question title'
  #     fill_in 'Body',	with: 'Question body'
  #     fill_in 'Link name', with: 'google'
  #     fill_in 'Url', with: 'https://google.com'
  #     click_on 'Ask'
  #     visit questions_path
  #     click_on 'Edit'

  #     click_on 'remove link'
  #     expect(page).to_not have_link('remove link')
  #     save_and_open_page
  #     click_on 'Save'
  #     click_on 'Show'

  #     expect(page).to_not have_link 'google'
  #   end
  # end
end
