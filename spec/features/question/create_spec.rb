require 'rails_helper'

feature 'User can create question', "
In order to get answer from community
As an authenticated user
I'd like to be able to ask a question
" do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      login(user)
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title',	with: 'Question title'
      fill_in 'Body',	with: 'Question body'

      click_on 'Ask'

      expect(page).to have_content 'Question created'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    scenario 'asks a question with invalid attributes' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated uset tries to ask question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
