class GreetController < ApplicationController
  skip_before_action :require_login, only: [:guest]
  def guest
  end

  def member
  end
end
