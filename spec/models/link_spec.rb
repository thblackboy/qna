require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { is_expected.to validate_url_of(:url) }

  describe '#gist?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:link) { create(:link, linkable: question) }
    let(:gist_link) { create(:link, :gist, linkable: question) }
    it 'should return true if link.url has match with gist.github.com' do
      expect(gist_link.gist?).to be_truthy
    end

    it 'should return false if link.url doent hava match with gist.github.com' do
      expect(link.gist?).to be_falsey
    end
  end
end
