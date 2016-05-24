@PlaylistTop = React.createClass
	getInitialState: ->
		viewTracks: false
		viewClusters: false
		waiting: false
		tracks: []
		clusters: []
		details: []


	printStat: (val, name) ->
		if val > 0
			return (val * 100).toFixed(0).toString() + '% more ' + name
		else
			return (val * -100).toFixed(0).toString() + '% less ' + name

	handleClick: (e) ->
		e.preventDefault()
		@setState viewTracks: !@state.viewTracks

	avgs: ->
		React.DOM.div
			className: 'playlist-stats'
			React.DOM.div
				className: 'subsection-header'
				React.DOM.h5
					className: 'ss-header'
					"Averages"
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.acousticness, 'acoustic')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.danceability, 'danceable')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.duration, 'time')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.energy, 'energy')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.explicit, 'curse words')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.instrumentalness, 'music without singing')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.liveness, 'liveness')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.loudness, 'hearing loss')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.speechiness, 'talk-singing')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.tempo, 'faster')
			React.DOM.div
				className: 'pstat'
				@printStat(@props.playlist.distinctions.averages.valence, 'happy feeling')
					React.DOM.hr null

	tracklist: ->
		$.get '/api/v1/playlists/' + @props.playlist.id.toString(), (data) =>
			@setState tracks: data['playlist']['tracks']
		for track in @state.tracks
			React.createElement BigTrackRow, name: track['name'], artists: track['artists'], length: track['duration'], spotify_link: track['href'], spotify: track['spotify_uri']

	handleCluster: (e) ->
		e.preventDefault()
		@setState viewClusters: !@state.viewClusters
		@getClusters()

	getClusters: ->
		@setState waiting: true
		$.get '/api/v1/playlists/' + @props.playlist.id.toString() + '/clusters', (data) =>
			@setState clusters: data['playlist_cluster']['clusters'], waiting: false

	clusterlist: ->	
		for num in [0..4]
			React.createElement ClusterCollapse, tracks: @state.clusters.clusters[0][num].slice(1), details: @state.clusters.clusters[1][num]


	render: ->
		React.DOM.div
			className: 'playlist-top'
			React.DOM.div
				className: 'ptop-container'
				React.DOM.div
					className: 'playlist-name'
					@props.playlist.name
				React.DOM.div
					className: 'buttons'
					React.DOM.a
						className: 'button'
						onClick: @handleClick
						'Check out the tracklist'
					React.DOM.a
						className: 'button'
						onClick: @handleCluster
						'See the clusters'
				React.DOM.div
					className: 'player-box'
					React.DOM.iframe
						className: 'audio'
						src: 'https://embed.spotify.com/?uri=' + @props.playlist.spotify_uri
						width: (screen.width / 5)
						height: 80
			React.DOM.div
				className: 'playlist-content-box'
				if @state.viewClusters and @state.waiting == false
					@clusterlist()
				else if @state.viewClusters and @state.waiting
					React.DOM.p
						className: 'waiting'
						'waiting...'
				else if @state.viewTracks
					@tracklist()
				else
					@avgs()

				
