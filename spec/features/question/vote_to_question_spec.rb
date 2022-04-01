require 'rails_helper'

feature 'User can vote to question', "
In order to show that user likes or dislikes question
As an authentificated user
I'like to be able to vote to question
", js: true do
    given(:user) { create(:user) }
    given(:another_user) { create(:user) }
    given!(:question) { create(:question, author: user) }

    describe 'Is not author of question' do
      background { login(another_user) }
      scenario 'votes up to question' do
        expect(page).to have_content question.title
        click_on 'Vote Up'
        expect(page).to have_content '1'
        expect(page).to_not have_content 'Vote Up'
        expect(page).to_not have_content 'Vote Down'
      end

      scenario 'votes down to question' do
        expect(page).to have_content question.title
        click_on 'Vote Down'
        expect(page).to have_content '-1'
        expect(page).to_not have_content 'Vote Up'
        expect(page).to_not have_content 'Vote Down'
      end

      scenario 'delete his vote from question' do
        create(:vote, :up, votable: question, voter: another_user)
        visit questions_path
        expect(page).to have_content question.title
        expect(page).to have_content '1'
        click_on 'Delete vote'
        expect(page).to have_content '0'
        expect(page).to_not have_content 'Delete vote'
      end
    end

    describe 'Is author of question or unauthentificated user' do
      scenario 'tries vote to question' do
        login(user)
        expect(page).to have_content question.title
        expect(page).to_not have_content 'Vote Up'
        expect(page).to_not have_content 'Vote Down'
        expect(page).to_not have_content 'Delete vote'
      end
    end
  end
