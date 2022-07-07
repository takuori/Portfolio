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
  
  def tags_save(tag_list)
    #current_tags = self.tags.pluck(:name) unless self.tags.nil?
    if self.tags != nil
      tag_posts_records = TagPost.where(post_id: self.id)
      tag_posts_records.destroy_all
    end

    tag_list.each do |tag|
      inspected_tags = Tag.where(name: tag).first_or_create
      self.tags << inspected_tags
    end
    #old_tags = current_tags - sent_tags
    #new_tags = sent_tags - current_tags

    #old_tags.each do |old|
      #self.tag_posts.delete Tag.find_by(name: old)
    #end

    #new_tags.each do |new|
      #new_tag_posts = Tag.find_or_create_by(name: new)
      #self.tag_posts << new_tag_posts
    #end
  end

  def liked_by?(member)
    likes.where(member_id: member.id).exists?
  end

end
