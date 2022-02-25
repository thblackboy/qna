require 'rails_helper'

feature 'Author of question can choose best answer', "
In order to show to community the best answer
As an author of question
I'd like to select the answer as the best for this question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:best_answer) { create(:answer, question: question, author: user) }

  describe 'is author of question', js: true do
    scenario 'chooses the best answer the first time' do
      login(user)
      expect(page).to have_content(question.title)
      click_on 'Show'
      within '.answers' do
        expect(page).to have_content(answer.body)
        click_on 'Best answer'
        expect(page).to_not have_content(answer.body)
      end

      within '.best-answer' do
        expect(page).to have_content(answer.body)
        expect(page).to_not have_content('Best answer')
      end
    end

    scenario 'chooses another best answer' do
      question.update(best_answer_id: best_answer.id)
      login(user)
      expect(page).to have_content(question.title)
      click_on 'Show'

      within '.best-answer' do
        expect(page).to have_content(best_answer.body)
      end
      within '.answers' do
        expect(page).to have_content(answer.body)
        click_on 'Best answer'
        expect(page).to_not have_content(answer.body)
        expect(page).to have_content(best_answer.body)
      end

      within '.best-answer' do
        expect(page).to have_content(answer.body)
      end
    end
  end

  scenario 'is not author of question' do
    login(another_user)
    expect(page).to have_content(question.title)
    click_on 'Show'
    expect(page).to_not have_content('Best answer')
  end
end
