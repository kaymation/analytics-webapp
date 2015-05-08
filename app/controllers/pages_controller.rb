class PagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to url_for(:controller => :restaurants, :action => :index)
    else
      render
    end
  end

  def help
  end
end
