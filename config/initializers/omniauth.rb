require 'rspotify/oauth'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :spotify, Rails.application.secrets.spotify_client_id, Rails.application.secrets.spotify_client_secret, redirect_uri: "http://localhost:3000/auth/spotify/callback", scope: 'user-top-read'
end