require 'rails_helper'

feature 'User can edit achieve for author of best answer', "
In order to edit reward author of best answer
As an author of question
I'd like to be able to edit a achieve for authtor of best answer
" do
  given(:user) { create(:user) }
  describe 'Author', js: true do
    given!(:question) { create(:question, author: user) }
    given!(:achieve) { create(:achieve, question: question) }
    given!(:answer) { create(:answer, question: question, author: user) }
    background do
      login(user)
      click_on 'Edit'
    end

    scenario 'edits achieve' do
      fill_in 'Achieve title',	with: 'new Guru'
      click_on 'Save'

      visit questions_path
      click_on 'Show'
      click_on 'Best answer'
      visit achieves_path

      expect(page).to have_content 'new Guru'
      expect(page).to_not have_content achieve.title
    end

    scenario 'edits achieve with invalid attributes' do
      fill_in 'Achieve title',	with: ''
      click_on 'Save'
      expect(page).to have_content "Achieve title can't be blank"
    end
  end
end
