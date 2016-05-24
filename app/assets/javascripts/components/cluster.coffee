@Cluster = React.createClass
	getInitialState: ->
		sorted: []
		atts: ['acousticness', 'danceability', 'duration', 'energy', 'instrumentalness', 'liveness', 'loudness', 'speechiness', 'tempo', 'valence']
	componentWillMount: ->
		for att in @state.atts
			@state.sorted.push([att, @props.details[att]])
		@setState sorted: @state.sorted.sort (a, b) ->
			x = a[1]
			y = b[1]
			return y - x
	render: ->
		React.DOM.div
			className: 'cluster'
			React.DOM.div
				className: 'differences'
				'Differences (% of playlist average)'
			for att in @state.sorted
				React.DOM.div
					className: 'difference'
					att[0] + ': ' + (att[1] * 100.0).toFixed(2).toString() + '%'
			React.DOM.hr null
			React.DOM.div
				className: 'tracks'
				'Tracks'
			for track in @props.tracks
				React.createElement BigTrackRow, name: track['name'], artists: track['artists'], length: track['duration'], spotify_link: track['href'], spotify: track['spotify_uri']
			React.DOM.hr null

