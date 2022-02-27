require 'rails_helper'

feature 'User can remove attached files', "
In order to delete useless files
As an author of answer
I'd like to be able remove attached files
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  background { answer.files.attach(fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }
  describe 'Authenticated user', js: true do
    scenario 'User tries to delete attach file of his answer' do
      login(user)
      expect(page).to have_content(question.title)
      click_on 'Show'

      within '.all-answers' do
        within '.file' do
          expect(page).to have_link('rails_helper.rb')
          click_on 'Delete file'
        end
        expect(page).to_not have_link('rails_helper.rb')
      end
    end

    scenario 'tries to delete attach file of not his answer' do
      login(another_user)

      expect(page).to have_content(question.title)
      click_on 'Show'

      within '.all-answers' do
        within '.file' do
          expect(page).to have_link('rails_helper.rb')
          expect(page).to_not have_link('Delete file')
        end
      end
    end
  end

  scenario 'Unathenticated user tries to delete attach file of his answer' do
    visit root_path
    expect(page).to have_content(question.title)
    click_on 'Show'

    within '.all-answers' do
      within '.file' do
        expect(page).to have_link('rails_helper.rb')
        expect(page).to_not have_link('Delete file')
      end
    end
  end
end
