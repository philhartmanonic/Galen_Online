class Vote < ActiveRecord::Base
	belongs_to :takes_votes, :polymorphic => true
	belongs_to :user
	validates :user_id, uniqueness: {
		scope: [:takes_votes_id, :takes_votes_type, :up]
	}
end
