require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should belong_to(:author) }

  it { should have_one(:best_for_question).dependent(:nullify) }

  it { should validate_presence_of(:body) }
end
