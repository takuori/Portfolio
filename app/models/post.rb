class Post < ApplicationRecord

  belongs_to :member
  has_many :notifications, dependent: :destroy
  has_many :tag_posts, dependent: :destroy
  has_many :tags, through: :tag_posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_members, through: :likes, source: :member

  has_one_attached :post_image

  def get_post_image
    if post_image.attached?
      #file_path = Rails.root.join('app/assets/images/no_image.jpg')
      #image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      post_image
    else
      'no_image.jpg'
    end
  end

  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'old'
      return all.order(created_at: :ASC)
    when 'likes'
      return find(Like.group(:post_id).order(Arel.sql('count(post_id) desc')).pluck(:post_id))
    when 'dislikes'
      return find(Like.group(:post_id).order(Arel.sql('count(post_id) asc')).pluck(:post_id))
    end
  end

  def liked_by?(member)
    likes.where(member_id: member.id).exists?
  end

  def tags_save(tag_list)
    if self.tags != nil
      tag_posts_records = TagPost.where(post_id: self.id)
      tag_posts_records.destroy_all
    end

    tag_list.each do |tag|
      inspected_tags = Tag.where(name: tag).first_or_create
      self.tags << inspected_tags
    end

  end



end
