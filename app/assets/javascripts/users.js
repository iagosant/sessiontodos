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
$(document).on("change", 'input#user_avatar', function(){

  // Get a reference to the fileList
  var files = !!this.files ? this.files : [];
  var element = $(this);

  // If no files were selected, or no FileReader support, return
  if ( !files.length || !window.FileReader ) return;

  // Only proceed if the selected file is an image
  if ( /^image/.test( files[0].type ) ) {
      // Create a new instance of the FileReader
      var reader = new FileReader();

      // Read the local file as a DataURL
      reader.readAsDataURL( files[0] );

      // When loaded, set image data as background of div
      reader.onloadend = function(){
          element.parents(".ms-upload-avatar").css("background-image", "url(" + this.result + ")");
          element.parents(".ms-upload-avatar").find('div.mousehover').addClass('active').removeClass('hover');
      }
  }
});
// CHANGE IMAGE IN USER NEW FILE UPLOAD
$(document).on("mouseout", 'label[for="user_avatar"]', function(){

  if ($('div.mousehover',this).hasClass('active'))
    {$('div.mousehover',this).toggleClass('hover');}

})
$(document).on("mouseover", 'label[for="user_avatar"]', function(){
  if (!$('div.mousehover', this ).hasClass('hover')){
    $( 'div.mousehover', this).toggleClass( 'hover' );
  }
});

// END
