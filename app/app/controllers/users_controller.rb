class UsersController < ApplicationController
  def index
    render plain: User.count
  end
end
