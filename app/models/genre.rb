class Genre < ActiveRecord::Base
	has_many :artists_genres
	has_many :artists, through: :artists_genres
	has_many :tracks_artists, through: :artists
	has_many :tracks, through: :tracks_artists
	has_many :playlists_tracks, through: :tracks
	has_many :playlists, through: :playlists_tracks
end