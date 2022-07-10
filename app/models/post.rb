class Post < ApplicationRecord

  belongs_to :member
  has_many :notifications, dependent: :destroy
  has_many :tag_posts, dependent: :destroy
  has_many :tags, through: :tag_posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_members, through: :likes, source: :member

  has_one_attached :post_image

  validates :location, presence: true
  validates :detail, length: { minimum: 2 }

  def get_post_image
    if post_image.attached?
      post_image
    end
  end
  
  def self.looks(search, word)
    if search == "perfect_matuch"
      @post = Post.where("location LIKE?", "#{word}")
    elsif search == "forward_match"
      @post = Post.where("location LIKE?", "#{word}%")
    elsif search == "backward_match"
      @post = Post.where("location LIKE?", "%#{word}")
    elsif search == "partial_match"
      @post = Post.where("location LIKE?", "%#{word}%")
    else
      @post = Post.all
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
