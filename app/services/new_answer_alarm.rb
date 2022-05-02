class NewAnswerAlarm
  def send_alarm(question)
    users = question.subscribers
    users.find_each(batch_size: 500) do |user|
      NewAnswerAlarmMailer.alarm(user, question).deliver_later
    end
  end
end
