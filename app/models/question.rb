class Question < ApplicationRecord
  include Votable
  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy
  has_one :achieve, class_name: 'Achieve', dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :achieve, reject_if: :all_blank

  validates :title, :body, presence: true
end
