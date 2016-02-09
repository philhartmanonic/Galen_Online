class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :takes_votes, dependent: :destroy
  accepts_nested_attributes_for :votes

  def score
  	return self.votes.where(up: true).count - self.votes.where(up: false).count
  end
end
