require 'rails_helper'

feature 'User can comment answers', "
In order to ask more details of question
As an authenticated user
I'd like to make a comment
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      login(user)
      click_on 'Show'
    end

    scenario 'add comment with valid attributes' do
      within '.comments' do
        fill_in 'Comment body', with: 'My comment'
        click_on 'Add comment'
        expect(page).to have_content 'My comment'
      end
    end

    scenario 'create coment with invalid attributes' do
      within '.comments' do
        click_on 'Add comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticate user tries to answer' do
    visit questions_path
    click_on 'Show'
    expect(page).to_not have_content 'Add comment'
  end

  context "multiply sessions" do
    given(:user) { create(:user) }
    scenario 'comment appears on another users page', js: true do
      Capybara.using_session('user') do
        login(user)
        click_on 'Show'
      end
      Capybara.using_session('guest') do
        visit questions_path
        click_on 'Show'
      end
      Capybara.using_session('user') do
        within '.comments' do
          fill_in 'Comment body', with: 'My comment'
          click_on 'Add comment'
          expect(page).to have_content 'My comment'
        end
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'My comment'
      end
    end
  end
end