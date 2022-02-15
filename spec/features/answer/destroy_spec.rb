require 'rails_helper'

feature 'User can delete his answer', "
In order to delete my incorrect answer
As an authenticated user
I'd like to delete my answer
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  describe 'Authenticated user' do
    background do
      login(user)
    end
    scenario 'User tries to delete his answer' do
      question.answers.create!(body: 'My answer', author_id: user.id)
      click_on 'Show'
      click_on 'Delete'

      expect(page).to_not have_content('My answer')
      expect(page).to have_content('Answer was deleted')
    end

    scenario 'tries to delete not his answer' do
      question.answers.create!(body: 'My answer', author_id: another_user.id)
      click_on 'Show'
      click_on 'Delete'

      expect(page).to have_content('My answer')
      expect(page).to have_content("You can't delete someone else's answer")
    end
  end

  scenario 'Unathenticated user tries to delete answer' do
    question.answers.create!(body: 'My answer', author_id: user.id)
    visit root_path
    click_on 'Show'
    click_on 'Delete'
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end
end
