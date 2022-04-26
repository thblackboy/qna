require 'rails_helper'

RSpec.describe NewAnswerAlarmMailer, type: :mailer do
  describe 'alarm' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:mail) { NewAnswerAlarmMailer.alarm(user, question) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Alarm')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
