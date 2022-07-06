class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  def get_profile_image
    if profile_image.attached?
      #file_path = Rails.root.join('app/assets/images/no_image.jpg')
      #image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      profile_image
    else
      'no_image.jpg'
    end
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def active_for_authentication?
    super && (is_deleted == false)
  end

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  #自分が作った通知
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  #自分宛の通知
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

end
