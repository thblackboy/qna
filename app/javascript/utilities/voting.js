$(document).on('turbolinks:load', function(){

  $('a.do-vote').on('ajax:success', function(e) {
    let item = e.detail[0];
    let voteBlock = $('#'+item.id).find('.votes');
    voteBlock.empty();
    voteBlock.append("<a class=\"delete-vote\" data-type=\"json\" data-remote=\"true\" data-method=\"delete\" href=\""+item.vote_destroy_path+"\">Delete vote</a>");
    voteBlock.append('<p>'+item.total+'</p>');
  })
  

  $('a.delete-vote').on('ajax:success', function(e) {
    let item = e.detail[0];
    let voteBlock = $('#'+item.id).find('.votes');
    voteBlock.empty();
    voteBlock.append("<a class=\"do-vote\" data-type=\"json\" data-remote=\"true\" rel=\"nofollow\" data-method=\"post\" href=\""+item.votable_url+"/vote_up\">Vote Up</a>")
    voteBlock.append("<a class=\"do-vote\" data-type=\"json\" data-remote=\"true\" rel=\"nofollow\" data-method=\"post\" href=\""+item.votable_url+"/vote_down\">Vote Down</a>")
    voteBlock.append('<p>'+item.total+'</p>');
  })
});