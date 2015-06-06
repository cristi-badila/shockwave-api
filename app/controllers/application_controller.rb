class ApplicationController < ActionController::Base
  def find_user
    begin
      @user = User.find(request.env['ACCESS_TOKEN'])
    rescue
      head 401
    end
  end
end
