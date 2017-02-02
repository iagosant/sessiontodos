module ListsHelper
  def owner?
    @list.owner == current_user
  end

  def has_collaborations?
    !@list.collaboration_users.empty?
  end

  def list_users
    @list_users = @list.collaboration_users.where.not(:id=> current_user.id)
  end

  def all_task?(list)
    list.name == 'All Tasks'
  end

end
