class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize!(:destroy, @file)
    @file.purge if @file.present?
  end
end
