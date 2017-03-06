class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  def not_authenticated
    redirect_to token_url
  end

  private
  
  def token_url
    "#{ENV['AUTH_URL']}/token?key=#{public_key(rsa)}"
  end

  def login_from_session
    token = redis.get("token:#{session.id}")
    return false if token.blank?
    sso_login(token)
  end
  
  def login_from_other_sources
    return false if params[:token].blank? || !restore_private_key
    begin
      token = rebuilt_rsa.private_decrypt(
        Base64.urlsafe_decode64(params[:token])
      )
    rescue 
      false
    else
      sso_login(token)
    end
  end

  def sso_login(token)
    @current_user = nil
    user = User.sso_authenticate(token)
    return nil unless user
    old_session = session.dup.to_hash
    reset_sorcery_session
    old_session.each_pair do |k, v|
      session[k.to_sym] = v
    end
    store_token(token)
    session.delete(:return_to_url)
    @current_user = user
  end
 
  def rebuilt_rsa
    rsa(restore_private_key)
  end

  def store_private_key(key)
    redis.setex("private_key:#{session.id}", 120, key)
  end

  def restore_private_key
    redis.get("private_key:#{session.id}")
  end

  def store_token(token)
    redis.setex("token:#{session.id}", 60, token)
  end

  def public_key(pair)
    store_private_key(pair.export)
    Base64.urlsafe_encode64(
      pair.public_key.export
    )
  end

  def rsa(param = 2048)
    OpenSSL::PKey::RSA.new param
  end

  def redis
    Redis.new(url: ENV['REDIS_URL'])
  end
end
