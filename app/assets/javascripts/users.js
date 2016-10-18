
// $(document).on('ready page:load', function () {
//
//   $('select').material_select();
//   $('select#role').on('change', function(){

$(document).on('turbolinks:load',function(){
  $('select#user_role').on('change', function(){

    var newSelect = $('select').val();
    console.log(newSelect);
    var userId = $(this).parents('.selected_role').attr('data');
    $.ajax({
      url: 'users/roleUpdate',
      type: 'POST',
      dataType: 'json',
      data: {'user_id': userId, 'new_role': newSelect},
      success: function(){
        alert ('user role was changed to' + newSelect);
      }
    });
  });

});
