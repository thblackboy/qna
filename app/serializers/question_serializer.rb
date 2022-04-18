class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :body, :author_id, :best_answer_id, :file_urls, :created_at, :updated_at
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
