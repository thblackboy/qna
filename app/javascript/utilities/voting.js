$(document).on('turbolinks:load', function(){

  $('a.do-vote').on('ajax:success', function(e) {
    let item = e.detail[0];
    console.log(e.detail);


    let voteBlock = $('#'+item.id).find('.votes');
    voteBlock.empty();
    voteBlock.append('<p>'+item.total+'</p>');
  })

  $('a.delete-vote').on('ajax:success', function(e) {
    let item = e.detail[0];
    console.log(e.detail);

    let voteBlock = $('#'+item.id).find('.votes');
    voteBlock.empty();
    voteBlock.append('<p>'+item.total+'</p>');
  })
});