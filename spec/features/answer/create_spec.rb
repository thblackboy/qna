require 'rails_helper'

feature 'User can create answer', "
In order to help to somebody
As an authenticated user
I'd like to be able to answer the question
" do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      login(user)
      click_on 'Show'
    end

    scenario 'create answer with valid attributes' do
      fill_in 'Body', with: 'My answer'
      click_on 'Create answer'
      within '.answers' do
        expect(page).to have_content 'My answer'
      end
    end

    scenario 'create answer and attach files' do
      fill_in 'Body', with: 'My answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'create answer with invalid attributes' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticate user tries to answer' do
    visit questions_path
    click_on 'Show'

    expect(page).to have_content 'Only authenticated users can make answers'
    expect(page).to_not have_content 'Create answer'
  end
end
