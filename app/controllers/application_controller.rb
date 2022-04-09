class ApplicationController < ActionController::Base
  before_action :set_gon_user, unless: :devise_controller?

  private

  def set_gon_user
    gon.user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.html  { redirect_to root_url, alert: e.message }
      format.json  { render json: e.message, status: :forbidden }
      format.js { render js: "alert('#{e.message}');", status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
