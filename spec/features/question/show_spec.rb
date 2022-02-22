require 'rails_helper'

feature 'User can see questions answers', "
In order to see question body and answers
As an unauthentificated user
I'like to be able to see question body and its answers
" do
  given(:question) { create(:question) }
  given(:author) { create(:user) }

  scenario 'User tries to see question and answers exist' do
    question.answers.create!(body: 'Question answer1', author_id: author.id)
    question.answers.create!(body: 'Question answer2', author_id: author.id)

    visit question_path(question)
    expect(page).to have_content 'Question text'
    expect(page).to have_content 'Question answer1'
    expect(page).to have_content 'Question answer2'
  end

  scenario 'User tries to see question and answers dont exist' do
    visit question_path(question)
    expect(page).to have_content 'Question text'
    expect(page).to have_content 'No answers'
  end
end
