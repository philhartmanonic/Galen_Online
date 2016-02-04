OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, Rails.application.secrets.FACEBOOK_APP_ID, Rails.application.secrets.FACEBOOK_SECRET
end