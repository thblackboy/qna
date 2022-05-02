class NewAnswerAlarmMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_alarm_mailer.alarm.subject
  #
  def alarm(user, question)
    @question = question

    mail to: user.email
  end
end
