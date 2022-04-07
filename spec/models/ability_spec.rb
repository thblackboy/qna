require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end
  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:another_question) { create(:question, author: another_user) }
    let(:another_question_answer) { create(:answer, author: user, question: another_question) }
    let(:answer) { create(:answer, author: user, question: question) }
    let(:another_answer) { create(:answer, author: another_user, question: question) }
    let(:vote) { create(:vote, :up, votable: another_question, voter: user) }
    let(:another_vote) { create(:vote, :up, votable: another_question, voter: another_user) }
    let!(:add_file) { question.files.attach(fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }
    let!(:add_another_file) { another_question.files.attach(fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, another_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, another_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, another_question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, another_answer }

    it { should be_able_to :vote_up, another_question }
    it { should be_able_to :vote_down, another_question }

    it { should_not be_able_to :vote_up, question }
    it { should_not be_able_to :vote_down, question }

    it { should be_able_to :vote_up, another_answer }
    it { should be_able_to :vote_down, another_answer }

    it { should_not be_able_to :vote_up, answer }
    it { should_not be_able_to :vote_down, answer }

    it { should be_able_to :destroy, vote }
    it { should_not be_able_to :destroy, another_vote }

    it { should be_able_to :add_comment, Question }
    it { should be_able_to :add_comment, Answer }

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, another_question.files.first }

    it { should be_able_to :set_best, answer }
    it { should_not be_able_to :set_best, another_question_answer }
  end
end
