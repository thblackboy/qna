import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if ($('.answers').length){
    if(this.answerCommentChannelSubscription)
      consumer.subscriptions.remove(this.answerCommentChannelSubscription);
    var subscription = consumer.subscriptions.create({ channel: "AnswerCommentChannel", question_id: gon.question_id }, {
      received(data) {
        if (data['author_id'] == gon.user_id)
          return;
        let htmlBlock = data['html'];
        $('.answer#'+data['answer_id']).children('.comments').prepend(htmlBlock);
      }
    });
    this.answerCommentChannelSubscription = subscription;
  }
})