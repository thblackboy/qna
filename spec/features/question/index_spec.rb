require 'rails_helper'

feature 'User can see question list', "
In order to find answer to needed question
As an unauthenticated user
I'd like to be able to see question list
" do
  scenario 'There are questions on site' do
    questions = create_list(:question, 3)
    visit questions_path
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
  end

  scenario 'There are not questions on site' do
    visit questions_path
    expect(page).to have_content 'No questions'
  end
end
