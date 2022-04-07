import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if ($('.answers').length){
    if(this.answerChannelSubscription)
      consumer.subscriptions.remove(this.answerChannelSubscription);
    var subscription = consumer.subscriptions.create({ channel: "AnswerChannel", id: gon.question_id }, {
      received(data) {
        if (data['author_id'] == gon.user_id)
          return;
        let htmlBlock;
        if (data['question_author_id'] == gon.user_id)
          htmlBlock = data['html']['question_author'];
        else if (typeof(gon.user_id) == "undefined")
          htmlBlock = data['html']['guest'];
        else
          htmlBlock = data['html']['user'];
        $('.answers').append(htmlBlock);
      }
    });
    this.answerChannelSubscription = subscription;
  }
})