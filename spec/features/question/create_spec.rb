require 'rails_helper'

feature 'User can create question', "
In order to get answer from community
As an authenticated user
I'd like to be able to ask a question
" do
  context "multiply sessions" do
    given(:user) { create(:user) }
    scenario 'question appears on another users page', js: true do
      Capybara.using_session('user') do
        login(user)
      end
      Capybara.using_session('guest') do
        visit root_path
      end
      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title',	with: 'Question title'
        fill_in 'Body',	with: 'Question body'
        click_on 'Ask'

        expect(page).to have_content 'Question created'
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Question body'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'Question title'
      end
    end
  end
  
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      login(user)
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title',	with: 'Question title'
      fill_in 'Body',	with: 'Question body'
      click_on 'Ask'

      expect(page).to have_content 'Question created'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    scenario 'asks a question and attach files' do
      fill_in 'Title',	with: 'Question title'
      fill_in 'Body',	with: 'Question body'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with invalid attributes' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated uset tries to ask question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'
  end
end
