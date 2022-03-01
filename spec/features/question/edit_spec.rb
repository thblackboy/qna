require 'rails_helper'

feature 'User can edit his question', "
In order to edit my incorrect question
As an authenticated user
I'd like to edit my question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  describe 'Authenticated user' do
    scenario 'User tries to edit his question and attach file', js: true do
      login(user)
      expect(page).to have_content(question.title)

      click_on 'Edit'

      fill_in 'Edit title',	with: 'New Question title'
      fill_in 'Edit body',	with: 'New Question body'
      attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'

      expect(page).to have_content('New Question title')
      click_on 'Show'
      expect(page).to have_content('New Question body')
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'User tries to edit his question with errors', js: true do
      login(user)
      expect(page).to have_content(question.title)

      click_on 'Edit'

      fill_in 'Edit title',	with: ''
      fill_in 'Edit body',	with: 'New Question body'
      click_on 'Save'

      expect(page).to have_content(question.title)
      expect(page).to have_content("Title can't be blank")
    end

    scenario 'tries to edit not his question' do
      login(another_user)

      expect(page).to have_content(question.title)
      expect(page).to_not have_content('Edit')
    end
  end

  scenario 'Unathenticated user tries to edit question' do
    visit root_path
    expect(page).to have_content(question.title)
    expect(page).to_not have_content('Edit')
  end
end
