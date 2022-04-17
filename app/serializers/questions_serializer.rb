class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :author_id, :best_answer_id, :created_at, :updated_at
end
