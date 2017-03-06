module ApplicationHelper
  def profile_url
    "#{ENV['AUTH_URL']}/profile"
  end
end
