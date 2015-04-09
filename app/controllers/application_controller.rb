class ApplicationController < ActionController::Base
layout "primary"
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  # force_ssl
  # before_filter :require_login
  # before_filter :current_user
  # before_filter :enforce_www
  # before_filter :disable_old_tags

protected

  def not_authenticated
    redirect_to @root, :alert => "Please login first."
  end
end
