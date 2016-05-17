class Artist < ActiveRecord::Base
	has_many :tracks_artists
	has_many :tracks, through: :tracks_artists
	has_many :artists_genres
	has_many :genres, through: :artists_genres
	has_many :playlists_tracks, through: :tracks
	has_many :playlists, through: :playlists_tracks

	def token
		refresh = HTTParty.post("https://accounts.spotify.com/api/token", headers: {"Authorization" => "Basic " + Rails.application.secrets.spotify_auth}, body: {"grant_type" => "refresh_token", "refresh_token" => Rails.application.secrets.spotify_token})
    	token = refresh["access_token"]
    	return token
    end

	def add_genres
		spotify_pull = HTTParty.get('https://api.spotify.com/v1/artists/' + self.spotify_id, headers: {'Authorization' => 'Bearer ' + self.token})
		genres = spotify_pull['genres']
		genres.each do |g|
			match = Genre.where(name: g)
			if match.count == 0
				self.genres.create(name: g)
			else
				specific_match = self.genres.where(name: g)
				if specific_match.count == 0
					self.genres << match[0]
				end
			end
		end
	end
end