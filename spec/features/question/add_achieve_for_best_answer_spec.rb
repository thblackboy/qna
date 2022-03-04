require 'rails_helper'

feature 'User can create achieve for author of best answer', "
In order to reward author of best answer
As an author of question
I'd like to be able to create a achieve for authtor of best answer
" do
  given(:user) { create(:user) }

  describe 'User creates question', js: true do
    background do
      login(user)
      click_on 'Ask question'
      fill_in 'Title',	with: 'Question title'
      fill_in 'Body',	with: 'Question body'
    end

    scenario 'adds achieve' do
      fill_in 'Achieve title',	with: 'Guru'
      attach_file 'Achieve image', "#{Rails.root}/spec/image.png"

      click_on 'Ask'
      expect(page).to have_content 'Question created'
      create(:answer, question: Question.first, author: user)

      visit questions_path
      click_on 'Show'
      click_on 'Best answer'
      visit achieves_path

      expect(page).to have_content 'Guru'
      expect(page).to have_content 'Question title'
    end

    scenario 'adds achieve with invalid attributes' do
      fill_in 'Achieve title',	with: 'Guru'
      click_on 'Ask'
      expect(page).to have_content "Achieve image can't be blank"
    end
  end
end
