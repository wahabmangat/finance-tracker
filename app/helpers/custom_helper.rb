module CustomHelper
  def current_page?(current_path)
    request.path == current_path
  end
  
  def current_user_id?(user_id)
    current_user.id == user_id
  end
end
