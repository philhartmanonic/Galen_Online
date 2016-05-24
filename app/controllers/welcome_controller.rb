class WelcomeController < ApplicationController
	require 'json'
	def welcome
		@posts = Post.all
		@recents = Post.order("created_at desc").limit(5)
  	end
	def about
	end

	def music
	  	json_playlists = Playlist.all.to_json({:methods => [:distinctions]})
	  	@playlists = JSON.parse(json_playlists)
	  	@tracks = Track.all
	  	@artists = Artist.all
	  	@genres = Genre.all
	  	refresh = HTTParty.post("https://accounts.spotify.com/api/token", headers: {"Authorization" => "Basic " + Rails.application.secrets.spotify_auth}, body: {"grant_type" => "refresh_token", "refresh_token" => Rails.application.secrets.spotify_token})
	    token = refresh["access_token"]
	    raw_recent = HTTParty.get('https://api.spotify.com/v1/me/top/artists?limit=5&time_range=short_term', headers: {"Authorization" => "Bearer " + token})
	    recent_bands = []
	    raw_recent["items"].each {|b| recent_bands << {id: b["id"], name: b["name"], genres: b["genres"], picture: b["images"][-1]["url"], picture2: b["images"][-2]["url"], popularity: b["popularity"]}}
	    @recent_bands = recent_bands.sort_by {|b| (b[:popularity] * -1)}
	    raw_all = HTTParty.get('https://api.spotify.com/v1/me/top/artists?limit=5&time_range=long_term', headers: {"Authorization" => "Bearer " + token})
	    all_bands = []
	    raw_all["items"].each {|b| all_bands << {id: b["id"], name: b["name"], genres: b["genres"], picture: b["images"][-1]["url"], popularity: b["popularity"]}}
	    @all_bands = all_bands.sort_by {|b| (b[:popularity] * -1)}
	end
end
