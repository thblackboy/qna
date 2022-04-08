import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if ($('.questions').length){
    if(!this.questionChannelSubscription){
      var subscription = consumer.subscriptions.create({ channel: "QuestionChannel" }, {
        received(data) {
          $('.questions').append(data);
        }
      });
      this.questionChannelSubscription = subscription;
    }
  }
})
