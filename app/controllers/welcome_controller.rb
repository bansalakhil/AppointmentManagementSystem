class WelcomeController < ApplicationController
  skip_before_action :authorize, only: [:new_signee]

  def new_signee
  end

  def index
  end
end
