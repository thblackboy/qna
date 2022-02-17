require 'rails_helper'

feature 'User can delete his answer', "
In order to delete my incorrect answer
As an authenticated user
I'd like to delete my answer
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  describe 'Authenticated user' do
    scenario 'User tries to delete his answer' do
      login(user)
      click_on 'Show'

      expect(page).to have_content(answer.body)

      click_on 'Delete'

      expect(page).to_not have_content(answer.body)
      expect(page).to have_content('Answer was deleted')
    end

    scenario 'tries to delete not his answer' do
      login(another_user)
      click_on 'Show'

      expect(page).to have_content(answer.body)
      expect(page).to_not have_content('Delete')
    end
  end

  scenario 'Unathenticated user tries to delete answer' do
    visit root_path
    click_on 'Show'
    expect(page).to have_content(answer.body)
    expect(page).to_not have_content('Delete')
  end
end
