require 'rails_helper'

feature 'User can add links when makes answer', "
In order to add links which complete answer
As an answers author
I'd like to be able to add links when make answer
" do
    describe 'Author', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given!(:answer) { create(:answer, author: user, question: question) }
    given!(:link) { create(:link, linkable: answer) }
    background do
      login(user)
      expect(page).to have_content question.title
      click_on 'Show'
    end

    scenario 'edits answers links' do
      within '.answers' do
        expect(page).to have_content answer.body
        click_on 'Edit'

        fill_in 'Link name', with: 'hello'
        click_on 'Save'
      end
      expect(page).to_not have_link 'google'
      expect(page).to have_link 'hello'
    end

    scenario 'edits answers links with invalid attribute' do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Link name', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Links name can't be blank"
    end
  end
end
