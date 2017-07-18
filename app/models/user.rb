class User < ActiveRecord::Base
  has_one  :page ,dependent: :destroy
  has_many :posts ,dependent: :destroy
  has_many :comments ,dependent: :destroy
  validates :date_of_birth, presence: true, on: :create

  acts_as_voter 

  has_many :active_relationships, class_name:  "Relationship",foreign_key: "follower_id", dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end






  if Rails.env == "production"
        S3_CREDENTIALS = {bucket: ENV.fetch('S3_BUCKET_NAME'),
                          access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
                          secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
                          s3_region: ENV.fetch('AWS_REGION')}

  else
        S3_CREDENTIALS = {bucket: ENV.fetch('S3_BUCKET_NAME'),
                          access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
                          secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
                          s3_region: ENV.fetch('AWS_REGION')}
  end

  has_attached_file :avatar,
                    styles:{ :cropped => '' ,large: "500x500>", medium: "300x300#", thumb: "100x100#" },
                    default_url: "https://s3.amazonaws.com/instatestbuck/user-icon.jpg",
                    storage:          :s3,
                    s3_credentials:   S3_CREDENTIALS
                    # path:             "avatar/:id/:style.:extension"

 validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/








  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def login=(login)
      @login = login
    end

    def login
      @login || self.username || self.email
    end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  validates :username, presence: true, length:{minimum:3}, uniqueness: {case_sensitive: false};


  # Only allow letter, number, underscore and punctuation.
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true


    validate :validate_username
      def validate_username
        if User.where(email: username).exists?
          errors.add(:username, :invalid)
        end
      end


      def self.find_for_database_authentication(warden_conditions)
         conditions = warden_conditions.dup
         if login = conditions.delete(:login)
           where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
         elsif conditions.has_key?(:username) || conditions.has_key?(:email)
           where(conditions.to_h).first
         end
       end

       def self.search(search)
             if search
                 where('username LIKE ?', "%#{search}%")
            #  else
            #      all
             end
       end

end
