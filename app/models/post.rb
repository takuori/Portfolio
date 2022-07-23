class Post < ApplicationRecord

  belongs_to :member
  has_many :notifications, dependent: :destroy
  has_many :tag_posts, dependent: :destroy
  has_many :tags, through: :tag_posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_members, through: :likes, source: :member

  has_one_attached :post_image

  enum status:{released: 0, nonreleased: 1}

  validates :location, presence: true
  validates :detail, length: { minimum: 2 }

  scope :latest, -> {order(updated_at: :desc)}
  scope :old, -> {order(updated_at: :asc)}
  scope :like_count, -> { includes(:likes).sort {|a,b| b.likes.size <=> a.likes.size}}

  def get_post_image
    if post_image.attached?
      post_image
    end
  end



  def self.looks(search, word)
    if search == "perfect_matuch"
      @post = Post.where("location LIKE? OR detail LIKE?", "#{word}", "#{word}")
    elsif search == "forward_match"
      @post = Post.where("location LIKE? OR detail LIKE?", "#{word}%", "#{word}%")
    elsif search == "backward_match"
      @post = Post.where("location LIKE? OR detail LIKE?", "%#{word}", "%#{word}")
    elsif search == "partial_match"
      @post = Post.where("location LIKE? OR detail LIKE?", "%#{word}%", "%#{word}%")
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

  def create_notification_like!(current_member)
      temp = Notification.where(["visiter_id = ? and visited_id = ? and post_id = ? and action = ? ", current_member.id, member_id, id, "like"])
      if temp.blank?
        notification = current_member.active_notifications.new(
          post_id: id,
          visited_id: member_id,
          action: "like"
        )
        if notification.visiter_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
      end
  end

  def create_notification_comment!(current_member, comment_id)
      temp_ids = Comment.select(:member_id).where(post_id: id).where.not(member_id: current_member.id).distinct
      temp_ids.each do |temp_id|
        save_notification_comment!(current_member, comment_id, temp_id['member_id'])
      end

      save_notification_comment!(current_member, comment_id, member_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_member, comment_id, visited_id)
      notification = current_member.active_notifications.new(
        post_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: "comment"
      )

      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end

      notification.save if notification.valid?
  end

end
