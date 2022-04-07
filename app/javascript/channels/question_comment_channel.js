import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if ($('.questions').length){
    if(!this.questionCommentChannelSubscription){
      var subscription = consumer.subscriptions.create({ channel: "QuestionCommentChannel" }, {
        received(data) {
          if (data['author_id'] == gon.user_id)
            return;
          let htmlBlock = data['html'];
          $('.question#'+data['question_id']).children('.comments').prepend(htmlBlock);
        }
      });
      this.questionCommentChannelSubscription = subscription;
    }
  }
})
