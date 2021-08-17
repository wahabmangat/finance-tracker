module CustomHelper
  def current_page?(current_url)
    request.path == current_url
  end
end