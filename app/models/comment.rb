class Comment < ActiveRecord::Base
  belongs_to :post
  validates :name, presence: true, length:{minimum:3};
end
