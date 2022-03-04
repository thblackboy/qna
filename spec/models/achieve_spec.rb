require 'rails_helper'

RSpec.describe Achieve, type: :model do
  it { should belong_to(:question) }
  it { should validate_presence_of(:title) }

  it 'should have one attached image' do
    expect(Achieve.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
