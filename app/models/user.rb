class User < ActiveRecord::Base
	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
	end

	def facebook
		@facebook ||= Koala::Facebook::API.new(oauth_token)
	end

	def fb_id
		@fb_id = @facebook.get_connection("me", "id")
	end

	has_and_belongs_to_many :bands
end
