class User < ApplicationRecord
  def self.sso_authenticate(token)
    where(token: token).first || false
  end
end
