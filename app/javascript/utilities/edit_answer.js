$(document).on('turbolinks:load', function(){
  $('.all-answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $('#edit-answer-'+answerId).toggle();
  });
})
