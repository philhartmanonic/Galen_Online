class Playlist < ActiveRecord::Base
	has_many :playlists_tracks
	has_many :tracks, through: :playlists_tracks
	has_many :tracks_artists, through: :tracks
	has_many :artists, through: :tracks_artists
	has_many :artists_genres, through: :artists
	has_many :genres, through: :artists_genres

	def token
		refresh = HTTParty.post("https://accounts.spotify.com/api/token", headers: {"Authorization" => "Basic " + Rails.application.secrets.spotify_auth}, body: {"grant_type" => "refresh_token", "refresh_token" => Rails.application.secrets.spotify_token})
    	token = refresh["access_token"]
    	return token
    end

	def get_tracks
		link = self.track_link
		get_more = true
		tracks_list = []
		while get_more == true
			spotify_pull = HTTParty.get(link, headers: {'Authorization' => 'Bearer ' + self.token})
			ts = spotify_pull['items']
			ts.each do |t|
				if t['track']['id'] != nil
					taf = HTTParty.get('https://api.spotify.com/v1/audio-features/' + t['track']['id'], headers: {'Authorization' => 'Bearer ' + self.token})
					tr = {'name' => t['track']['name'], 'artists' => t['track']['artists'], 'duration' => t['track']['duration_ms'], 'explicit' => t['track']['explicit'], 'danceability' => taf['danceability'], 'energy' => taf['energy'], 'key' => taf['key'], 'time_signature' => taf['time_signature'], 'loudness' => taf['loudness'], 'mode' => taf['mode'], 'speechiness' => taf['speechiness'], 'acousticness' => taf['acousticness'], 'instrumentalness' => taf['instrumentalness'], 'liveness' => taf['liveness'], 'valence' => taf['valence'], 'tempo' => taf['tempo'], 'spotify_id' => t['track']['id'], 'spotify_uri' => t['track']['uri'], 'href' => t['track']['href']}
					tracks_list << tr
				end
			end
			if spotify_pull['next'] == nil
				get_more = false
			else
				link = spotify_pull['next']
			end
		end
		return tracks_list
	end

	def populate
		songs = self.get_tracks
		songs.each do |song|
			song_match = Track.where(spotify_id: song[spotify_id])
			if song_match.count == 0
				s = self.tracks.create(name: song['name'], duration: song['duration'], explicit: song['explicit'], danceability: song['danceability'], energy: song['energy'], key: song['key'], loudness: song['loudness'], mode: song['mode'], speechiness: song['speechiness'], acousticness: song['acousticness'], instrumentalness: song['instrumentalness'], liveness: song['liveness'], valence: song['valence'], tempo: song['tempo'], spotify_id: song['spotify_id'], spotify_uri: song['spotify_uri'], href: song['href'], time_signature: song['time_signature'])
			else
				s = song_match[0]
				self.tracks << s
			end
			if s.artists.count == 0
				song['artists'].each do |a|
					match = Artist.where(spotify_id: a['id'])
					if match.count == 0
						s.artists.create(name: a['name'], spotify_id: a['id'], spotify_uri: a['uri'])
					else
						s.artists << match[0]
					end
				end
			end
		end
	end

	def genre_frequency
		freq = {}
		self.genres.each do |g|
			if freq.key? g.name
				freq[g.name] += 1
			else
				freq[g.name] = 1
			end
		end
		final = freq.sort_by{|k, v| v * -1}
		return final
	end

	def track_averages
		averages = {'duration' => 0, 'explicit' => 0.0, 'danceability' => 0, 'energy' => 0, 'loudness' => 0, 'speechiness' => 0, 'acousticness' => 0, 'instrumentalness' => 0, 'liveness' => 0, 'valence' => 0, 'tempo' => 0, 'time_signature' => 0}
		self.tracks.each do |t|
			averages['duration'] += t.duration
			if t.explicit
				averages['explicit'] += 1.0
			end
			averages['danceability'] += t.danceability
			averages['energy'] += t.energy
			averages['loudness'] += t.loudness
			averages['speechiness'] += t.speechiness
			averages['acousticness'] += t.acousticness
			averages['instrumentalness'] += t.instrumentalness
			averages['liveness'] += t.liveness
			averages['valence'] += t.valence
			averages['tempo'] += t.tempo
			averages['time_signature'] += t.time_signature
		end
		c = self.tracks.count
		averages['duration'] /= c
		averages['explicit'] /= c
		averages['danceability'] /= c
		averages['energy'] /= c
		averages['loudness'] /= c
		averages['speechiness'] /= c
		averages['acousticness'] /= c
		averages['instrumentalness'] /= c
		averages['liveness'] /= c
		averages['valence'] /= c
		averages['tempo'] /= c
		averages['time_signature'] /= c
		return averages
	end

	def track_std_variance
		difs = {'duration' => 0, 'explicit' => 0.0, 'danceability' => 0, 'energy' => 0, 'loudness' => 0, 'speechiness' => 0, 'acousticness' => 0, 'instrumentalness' => 0, 'liveness' => 0, 'valence' => 0, 'tempo' => 0, 'time_signature' => 0}
		avgs = self.track_averages
		self.tracks.each do |t|
			difs['duration'] += ((t.duration - avgs['duration']) ** 2)
			if t.explicit
				difs['explicit'] += ((1 - avgs['explicit']) ** 2)
			else
				difs['explicit'] += ((0 - avgs['explicit']) ** 2)
			end
			difs['danceability'] += ((t.danceability - avgs['danceability']) ** 2)
			difs['energy'] += ((t.energy - avgs['energy']) ** 2)
			difs['loudness'] += ((t.loudness - avgs['loudness']) ** 2)
			difs['speechiness'] += ((t.speechiness - avgs['speechiness']) ** 2)
			difs['acousticness'] += ((t.acousticness - avgs['acousticness']) ** 2)
			difs['instrumentalness'] += ((t.instrumentalness - avgs['instrumentalness']) ** 2)
			difs['liveness'] += ((t.liveness - avgs['liveness']) ** 2)
			difs['valence'] += ((t.valence - avgs['valence']) ** 2)
			difs['tempo'] += ((t.tempo - avgs['tempo']) ** 2)
			difs['time_signature'] += ((t.time_signature - avgs['time_signature']) ** 2)
		end
		c = self.tracks.count
		difs['duration'] /= c
		difs['explicit'] /= c
		difs['danceability'] /= c
		difs['energy'] /= c
		difs['loudness'] /= c
		difs['speechiness'] /= c
		difs['acousticness'] /= c
		difs['instrumentalness'] /= c
		difs['liveness'] /= c
		difs['valence'] /= c
		difs['tempo'] /= c
		difs['time_signature'] /= c
		return difs
	end

	def track_std_dev
		difs = self.track_std_variance
		stdDevs = {}
		stdDevs['duration'] = Math.sqrt(difs['duration'])
		stdDevs['explicit'] = Math.sqrt(difs['explicit'])
		stdDevs['speechiness'] = Math.sqrt(difs['speechiness'])
		stdDevs['danceability'] = Math.sqrt(difs['danceability'])
		stdDevs['energy'] = Math.sqrt(difs['energy'])
		stdDevs['loudness'] = Math.sqrt(difs['loudness'])
		stdDevs['duration'] = Math.sqrt(difs['speechiness'])
		stdDevs['acousticness'] = Math.sqrt(difs['acousticness'])
		stdDevs['instrumentalness'] = Math.sqrt(difs['instrumentalness'])
		stdDevs['liveness'] = Math.sqrt(difs['liveness'])
		stdDevs['valence'] = Math.sqrt(difs['valence'])
		stdDevs['tempo'] = Math.sqrt(difs['tempo'])
		stdDevs['time_signature'] = Math.sqrt(difs['time_signature'])
		return stdDevs
	end

	def kmeans(cent, iters)
		songs = []
		self.tracks.each {|t| songs << t}
		stdDevs = self.track_std_dev
		centrs = []
		cent.times do |c|
			centrs << songs[songs.count - (songs.count / (c + 1))]
		end
		attris =['duration', 'danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'time_signature']
		iters.times do |i|
			clusters = []
			cent.times {|c| clusters << []}
			songs.each do |s|
				distances = {}
				cent.times do |c|
					distances[c + 1] = 0
					attris.each do |a|
						if stdDevs[a] > 0
							distances[c + 1] += ((s[a] - centrs[c][a]).abs / stdDevs[a])
						end
					end
				end
				d = distances.sort_by {|k, v| v}
				ind = d[0][0] - 1
				clusters[ind] << s
			end
			if i + 1 == iters
				counter = 0
				clusters.each do |cl|
					means = {}
					attris.each {|a| means[a] = 0}
					cl.each do |s|
						if cl.count > 0
							attris.count.times do |t|
								means[attris[t]] += s[attris[t]]
							end
						end
					end
					attris.each {|a| means[a] /= cl.count}
					means['tracks'] = cl.count
					minutes = ((means['duration'].to_f / 1000) / 60).floor
					seconds = (means['duration'].to_f / 1000) - (minutes * 60)
					if seconds.to_i < 10
						means['duration'] = minutes.to_s + ':0' + seconds.to_i.to_s
					else
						means['duration'] = minutes.to_s + ':' + seconds.to_i.to_s
					end
					means['name'] = 'cluster' + counter.to_s
					cl.unshift(means)
					counter += 1
				end
				return clusters
			else
				centrs = []
				clusters.each do |cl|
					means = {}
					attris.each {|a| means[a] = 0}
					cl.each do |s|
						if cl.count > 0
							attris.count.times do |t|
								means[attris[t]] += s[attris[t]]
							end
						end
					end
					attris.each {|a| means[a] /= cl.count}
					puts means
					centrs << means
					puts i
					clusters.each do |c|
						puts c
						puts ''
					end
				end
			end
		end
	end

	def clusters_and_differences(cent, iters)
		clusters = self.kmeans(cent, iters)
		stats = []
		clusters.each do |c|
			m, s = c[0]['duration'].split(':')
			puts 'm: ' + m
			puts 's: ' + s
			ms = (m.to_i * 60000) + (s.to_i * 1000)
			c[0]['duration'] = ms.to_f
		end
		clusters.each {|c| stats << c[0]}
		attris = ['duration', 'danceability', 'energy', 'loudness', 'speechiness', 'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'time_signature']
		differences = []
		means = {}
		attris.each do |a|
			total = 0
			stats.each do |s|
				total += s[a]
			end
			means[a] = total / cent
		end
		stats.each do |s|
			dif = {'name' => s['name']}
			attris.each do |a|
				dif[a] = s[a] / means[a]
			end
			differences << dif
		end
		difs = []
		differences.each do |d|
			name = d['name']
			d.delete('name')
			newHash = Hash[(d.sort_by {|k, v| v * -1}).map{|key, value| [key, value]}]
			newHash['name'] = name
			difs << newHash
		end
		return clusters, difs
	end

end 