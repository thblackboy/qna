# Preview all emails at http://localhost:3000/rails/mailers/new_answer_alarm
class NewAnswerAlarmPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_alarm/alarm
  def alarm
    NewAnswerAlarmMailer.alarm
  end

end
