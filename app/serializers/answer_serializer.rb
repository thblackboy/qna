class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :body, :author_id, :question_id, :file_urls, :created_at, :updated_at
  has_many :links
  has_many :comments

  def file_urls
    urls = []
    object.files.each do |file|
      urls << url_for(file)
    end
    return urls
  end
end
