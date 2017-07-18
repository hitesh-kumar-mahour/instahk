class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments ,dependent: :destroy
  acts_as_votable 

  has_attached_file :image, styles: {
     medium: "500x500>",
     large: "1000x1000>",
     thumb: "100x100>" },
     default_url: "https://s3.amazonaws.com/instatestbuck/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates :description, presence: true, length:{minimum:3};
end
