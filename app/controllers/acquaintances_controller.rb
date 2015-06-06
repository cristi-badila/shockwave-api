class AcquaintancesController < ApplicationController
  respond_to :json

  before_filter :find_user

  def index
    respond_with @user.acquaintances
  end
end