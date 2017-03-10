module ListsHelper
  def owner?
    current_list.owner == current_user
  end

  def has_collaborations?
    !current_list.collaboration_users.empty?
  end

  def list_users
    @list_users = current_list.collaboration_users.where.not(:id=> current_user.id)
  end

  def all_task?(id)
    List.find(id).name == 'All Tasks'
  end

end
