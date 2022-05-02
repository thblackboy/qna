class NewAnswerAlarmJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    NewAnswerAlarm.new.send_alarm(question)
  end
end
