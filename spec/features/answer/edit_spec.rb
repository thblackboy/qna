require 'rails_helper'

feature 'User can edit his answer', "
In order to edit my incorrect answer
As an authenticated user
I'd like to edit my answer
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  describe 'Authenticated user' do
    scenario 'User tries to edit his answer and attach file', js: true do
      login(user)
      expect(page).to have_content(question.title)

      click_on 'Show'

      expect(page).to have_content(answer.body)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Edit body',	with: 'New answer body'
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'

        expect(page).to have_content('New answer body')
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'User tries to edit his answer with errors', js: true do
      login(user)
      expect(page).to have_content(question.title)

      click_on 'Show'

      expect(page).to have_content(answer.body)

      click_on 'Edit'
      within '.answers' do
        fill_in 'Edit body',	with: ''
        click_on 'Save'

        expect(page).to have_content(answer.body)
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'tries to edit not his answer' do
      login(another_user)

      expect(page).to have_content(question.title)

      click_on 'Show'

      expect(page).to have_content(answer.body)
      expect(page).to_not have_content('Edit')
    end
  end

  scenario 'Unathenticated user tries to edit answer' do
    visit root_path
    expect(page).to have_content(question.title)

    click_on 'Show'

    expect(page).to have_content(answer.body)
    expect(page).to_not have_content('Edit')
  end
end
