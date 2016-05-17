class Track < ActiveRecord::Base
	has_many :playlists_tracks
	has_many :playlists, through: :playlist_tracks
	has_many :tracks_artists
	has_many :artists, through: :tracks_artists
	has_many :artists_genres, through: :artists
	has_many :genres, through: :artists_genres
end