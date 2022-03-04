class AchievesController < ApplicationController
  before_action :authenticate_user!
  expose(:achieves) { current_user.achieves }
end
