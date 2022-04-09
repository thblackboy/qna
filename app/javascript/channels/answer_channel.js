import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if ($('.answers').length){
    if(this.answerChannelSubscription)
      consumer.subscriptions.remove(this.answerChannelSubscription);
    var subscription = consumer.subscriptions.create({ channel: "AnswerChannel", id: gon.question_id }, {
      received(data) {
        if (data['author_id'] == gon.user_id)
          return;
        $('.answers').prepend(data['html']);
      }
    });
    this.answerChannelSubscription = subscription;
  }
})