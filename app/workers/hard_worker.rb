class HardWorker
	include Sidekiq::Worker
	def perform(name, count)
		refresh = HTTParty.post("https://accounts.spotify.com/api/token", headers: {"Authorization" => "Basic " + Rails.application.secrets.spotify_auth}, body: {"grant_type" => "refresh_token", "refresh_token" => Rails.application.secrets.spotify_token})
    	token = refresh["access_token"]
    	