class CreateTrackAndSong < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
    	t.string :name
    	t.string :href
    	t.string :spotify_id
    	t.string :spotify_uri
    	t.string :track_link
    	t.timestamps null: false
    end
    create_table :tracks do |t|
    	t.string :name
    	t.integer :duration
    	t.boolean :explicit
    	t.float :danceability
    	t.float :energy
    	t.integer :key
    	t.float :loudness
    	t.integer :mode
    	t.float :speechiness
    	t.float :acousticness
    	t.float :instrumentalness
    	t.float :liveness
    	t.float :valence
    	t.float :tempo
    	t.string :spotify_id
    	t.string :spotify_uri
    	t.string :href
    	t.integer :time_signature
    	t.timestamps null: false
    end
    create_table :genres do |t|
    	t.string :name
    end
    create_table :artists do |t|
    	t.string :name
    	t.string :spotify_uri
    	t.string :spotify_id
    	t.timestamps null: false
    end
    create_table :playlists_tracks do |t|
    	t.belongs_to :track, index: true
    	t.belongs_to :playlist, index: true
    	t.timestamps null: false
    end
    create_table :tracks_artists do |t|
    	t.belongs_to :track, index: true
    	t.belongs_to :artist, index: true
    	t.timestamps null: false
    end
    create_table :artists_genres do |t|
    	t.belongs_to :artist, index: true
    	t.belongs_to :genre, index: true
    	t.timestamps null: false
    end
  end
end
