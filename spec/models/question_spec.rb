require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:achieve).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for(:links) }

  it 'should have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
end
