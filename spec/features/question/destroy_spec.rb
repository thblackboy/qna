require 'rails_helper'

feature 'User can delete his question', "
In order to delete my incorrect question
As an authenticated user
I'd like to delete my question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  describe 'Authenticated user' do
    scenario 'User tries to delete his question' do
      login(user)
      expect(page).to have_content(question.title)

      click_on 'Delete'

      expect(page).to_not have_content(question.title)
      expect(page).to have_content('Question was deleted')
    end

    scenario 'tries to delete not his question' do
      login(another_user)

      expect(page).to have_content(question.title)
      expect(page).to_not have_content('Delete')
    end
  end

  scenario 'Unathenticated user tries to delete question' do
    visit root_path
    expect(page).to have_content(question.title)
    expect(page).to_not have_content('Delete')
  end
end
