class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :created_at, :updated_at
end
