class Comment < ApplicationRecord

  has_many :notifications, dependent: :destroy

  belongs_to :member

  belongs_to :post

  validates :comment, presence: true
end
