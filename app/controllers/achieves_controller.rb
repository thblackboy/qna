class AchievesController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check
  expose(:achieves) { current_user.achieves }
end
