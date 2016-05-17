class Post < ActiveRecord::Base
	belongs_to :user
	has_many :comments
	has_many :votes, as: :takes_votes, dependent: :destroy
	accepts_nested_attributes_for :comments
	accepts_nested_attributes_for :votes
	accepts_nested_attributes_for :user
	has_attached_file :main_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :main_image, content_type: /\Aimage\/.*\Z/

	def score
		return self.votes.where(up: true).count - self.votes.where(up: false).count
	end

	def has_comments?
		self.comments.load
		return self.comments.any?
	end

	def formatted_created_time
		self.created_at.strftime("%B %d, %Y at %l:%M %P")
	end

	def self.top_playlists
		get_more_playlists = true
		playlists = []
		names = []
		refresh = HTTParty.post("https://accounts.spotify.com/api/token", headers: {"Authorization" => "Basic " + Rails.application.secrets.spotify_auth}, body: {"grant_type" => "refresh_token", "refresh_token" => Rails.application.secrets.spotify_token})
    	token = refresh["access_token"]
    	link = 'https://api.spotify.com/v1/me/playlists'
    	while get_more_playlists == true
    		playlist_get = HTTParty.get(link, headers: {'Authorization' => 'Bearer ' + token})
    		playlist_get['items'].each do |play|
    			names << play['name']
    			playlists << {'name' => play['name'], 'track_link' => play['tracks']['href'], 'id' => play['id'], 'url' => play['external_urls']['spotify']}
    		end
    		if playlist_get['next'].nil?
    			get_more_playlists = false
    		else
    			link = playlist_get['next']
    		end
    	end
    	top_names = names[0..9]
    	top_playlists = []
    	playlists.each do |p|
    		if top_names.include? p['name']
    			top_playlists << p
    		end
    	end
    	return top_playlists
    end

    def self.playlist_tracks
    	tracks = {}
    	playlists = self.top_playlists
    	refresh = HTTParty.post("https://accounts.spotify.com/api/token", headers: {"Authorization" => "Basic " + Rails.application.secrets.spotify_auth}, body: {"grant_type" => "refresh_token", "refresh_token" => Rails.application.secrets.spotify_token})
    	token = refresh["access_token"]
    	playlists.each do |playlist|
    		link = playlist['track_link']
    		current_tracks = []
    		get_more_tracks = true
    		while get_more_tracks == true
    			track_get = HTTParty.get(link, headers: {'Authorization' => 'Bearer ' + token})
    			artists = []
    			track_get['items'].each do |t|
    				if t['track']['id'] != nil
	    				track = t['track']
	    				audio_features = HTTParty.get('https://api.spotify.com/v1/audio-features/' + track['id'], headers: {'Authorization' => 'Bearer ' + token})
	    				track['artists'].each do |artist|
	    					artist_details = HTTParty.get(artist['href'], headers: {'Authorization' => 'Bearer ' + token})
	    					artists << {'name' => artist['name'], 'id' => artist['id'], 'href' => artist['href'], 'details' => artist_details}
	    				end
	    				current_tracks << {'name' => track['name'], 'artists' => artists, 'audio_features' => audio_features, 'duration' => track['duration_ms'], 'explicit' => track['explicit'], 'popularity' => track['popularity'], 'id' => track['id'], 'uri' => track['uri'], 'href' => track['href']}
	    			end
    			end
    			if track_get['next'].nil?
    				get_more_tracks = false
    			else
    				link = track_get['next']
    			end
    		end
    		tracks[playlist['name']] = current_tracks
    		puts playlist['name'] 
    		puts current_tracks
    	end
    	return tracks
    end

	private
	
	def to_html
    Jekyll::Converters::Markdown::RedcarpetParser.new({
      'highlighter' => 'rouge',
      'redcarpet' => {
        'extensions' => [
          "no_intra_emphasis", "fenced_code_blocks", "autolink",
          "strikethrough", "lax_spacing",  "superscript", "with_toc_data"
        ]
      }
    }).convert(markdown)
  end
end
