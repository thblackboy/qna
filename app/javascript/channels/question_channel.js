import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if ($('.questions').length){
    if(!this.questionChannelSubscription){
      var subscription = consumer.subscriptions.create({ channel: "QuestionChannel" }, {
        received(data) {
          $('.questions').prepend(data);
        }
      });
      this.questionChannelSubscription = subscription;
    }
  }
})
