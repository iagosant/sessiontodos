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

  // var $input = $('.datepicker').pickadate();

  // $('.datepicker').datepicker({
  //   onClose: function (){
  //     var date = $(this).val();
  //     $(this).val(date);
  //     $(this).parent('form').submit();
  //     console.log(date);
  //   }
  // });

  $('#application_date .datepicker').pickadate({
      selectMonths: true, // Creates a dropdown to control month
      selectYears: 15, // Creates a dropdown of 15 years to control year
      closeOnSelect: true,
      hiddenName: true,
      onClose: function (){
        $('#form_date').val(this.get());
        this.$root.parent('form').submit();
        console.log(this.get());
       },
       onStart: function (){
          var date = new Date()
          this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
      },

    });

    $('#user_lists a').on('click', function(){
        event.preventDefault();
        var date = $('#form_date').val() ? $('#form_date').val(): new Date();
        $.ajax({
           complete:function(request){},
           data:'date='+ date,
           dataType:'script',
           type:'get',
           url: $(this).attr('data-href')
         })
    });


});
