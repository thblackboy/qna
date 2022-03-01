class AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user.author_of?(@file.record) && @file.present?
  end
end
