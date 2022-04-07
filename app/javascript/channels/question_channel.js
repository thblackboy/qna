import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if ($('.questions').length){
    if(!this.questionChannelSubscription){
      var subscription = consumer.subscriptions.create({ channel: "QuestionChannel" }, {
        received(data) {
          var htmlBlock;
          if (data['author_id'] == gon.user_id)
            htmlBlock = data['html']['author'];
          else if (typeof(gon.user_id) == "undefined")
            htmlBlock = data['html']['guest'];
          else
            htmlBlock = data['html']['user'];
          $('.questions').append(htmlBlock);
        }
      });
      this.questionChannelSubscription = subscription;
    }
  }
})
