class WelcomeController < ApplicationController
  skip_before_action :authorize, only: [:new_sign_up]
  def new_sign_up
  end

  def index
  end
end
