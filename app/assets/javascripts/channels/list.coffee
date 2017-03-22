App.list = App.cable.subscriptions.create "ListChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $list = $('[data-list-id = "' + data.list_id + '"]')
    $user = $('[data-user-id = "' + data.user + '"]', $list)
    # $('#list_user_' + data['user'] + ' #incomplete_tasks')
    $task = $('[data-task-id = "' + data.id + '"]', $user)

    if $task.length > 0
      switch data.status
        when 'saved'
          $task.replaceWith data.html
          $('#edit_task_' + data['id'], $task).submitOnCheck()
        when 'deleted'
          $task.remove()
        when 'completed'
          $task.remove()
          alert data['html']
          $('#complete_tasks', $user).prepend data['html']
          $('#edit_task_' + data['id'], $task).submitOnCheck()

    else

      $('#incomplete_tasks', $user).prepend data['html']
      $('#edit_task_' + data['id'], $task).submitOnCheck()
      $('#list_user_' + data['user'] + ' .new_task #detail').val('');
    #
    #
    # unless data['task'].blank
    #
    #   alert data['status']
    #   div.prepend data['task']
    # num = $('#' + data.task.list_id + ' .secondary-content span#num')

      # $num_incompleted_tasks.html '<%= current_user.num_incompleted_tasks(@list)%>'
      # $('#messages-table').append '<div class="message">' +
      #   '<div class="message-user">' + data.username + ":" + '</div>' +
      #   '<div class="message-content">' + data.content + '</div>' + '</div>'

    # //  $('#list_user_<%=@user.id%> #incomplete_tasks').append('<%=# j render partial: "task", layout: "incompleted", locals: {task: @task}  %>');
    # //  var $num_incompleted_tasks= $('#<%= #@list.id%> .secondary-content span#num');
    # //  $num_incompleted_tasks.html('<%= #current_user.num_incompleted_tasks(@list)%>');
    # //  $('#edit_task_<%=# @task.id %>').submitOnCheck();
    # //  $('.new_task #detail').val('');

  submit_task = () ->
  $('#new_task #detail').on 'keydown', (event) ->
    if event.keyCode is 13
      $('#new_task #create_task_button').click()
      event.target.value = ""
      event.preventDefault()





# App.list = App.cable.subscriptions.create("ListChannel", {
#   connected: function() {
#     // Called when the subscription is ready for use on the server
#   },
#
#   disconnected: function() {
#     // Called when the subscription has been terminated by the server
#   },
#
#   received: function(data) {
#
#     // Called when there's incoming data on the websocket for this channel
#   }
# });
