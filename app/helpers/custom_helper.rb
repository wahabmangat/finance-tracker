module CustomHelper
  def current_page?(current_url)
    request.path == current_url
  end
  def current_user_id?(user_id)
    current_user.id == user_id
  end
end
