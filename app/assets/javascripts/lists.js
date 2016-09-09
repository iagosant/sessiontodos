// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load',function(){
  $('.modal-trigger').leanModal();
  $('.edit_task').submitOnCheck();
  $('.collection-item').click(function(){
    $('.collection-item').removeClass('active');
    $(this).addClass('active');
  });

  // $('#deadline').on('click', function(){
  //   var deadline = $("input#datepicker").val()
  //   alert(deadline);
  // });

  var $input = $('.datepicker').pickadate();

  $('.datepicker').datepicker({
    onClose: function (){
      var date = $(this).val();
      $(this).val(date);
      $(this).parent('form').submit();
      console.log(date);
    }
  });

});
