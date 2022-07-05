class TagPost < ApplicationRecord

  belongs_to :post
  belongs_to :tag

  #PostとTagの関係を構築する際に２つの外部キーが存在することは
  #絶対なのでバリデーションを張っている
  validates :post_id, presence: true
  validates :tag_id, presence: true
end
