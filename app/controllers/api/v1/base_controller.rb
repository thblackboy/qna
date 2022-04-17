class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_authorization_check

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def authorize(method, object)
    raise CanCan::AccessDenied unless Ability.new(current_resource_owner).can? method.to_sym, object
  end
end