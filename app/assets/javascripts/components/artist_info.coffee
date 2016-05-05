@ArtistInfo = React.createClass
	getInitialState: ->
		related: []
		toptracks: []
		tracks: ''
		related_artists: ''
		counter: 0
	componentDidMount: ->
		$.when(
			$.get('https://api.spotify.com/v1/artists/' + @props.id + '/top-tracks?country=US', (data) =>
				@setState tracks: data["tracks"]
				for track in @state.tracks
					toptracks = @state.toptracks.slice()
					toptracks.push {name: track['name'], length: track['duration_ms'], demo: track['preview_url'], spotify_link: track['external_urls']['spotify'], spotify: track['uri']}
					@setState toptracks: toptracks
			)
			$.get('https://api.spotify.com/v1/artists/' + @props.id + '/related-artists', (data) =>
				@setState related_artists: data["artists"]
				for artist in @state.related_artists
					related = @state.related.slice()
					related.push {name: artist['name'], picture: artist['images'][artist['images'].length - 1]["url"]}
					@setState related: related
			)
		)
	makeDivstyle: (artist) ->
		{
			backgroundImage: 'url(' + artist.picture + ')',
			backgroundSize: 'cover'
		}
	handleArtist: (artist) ->
		if @state.related.indexOf(artist) % 3 == 0
			React.createElement RelatedArtistBox, name: artist['name'], picture: artist['picture'], newline: true
		else
			React.createElement RelatedArtistBox, name: artist['name'], picture: artist['picture'], newline: false
	render: ->
		React.DOM.div
			className: 'music-info-box'
			React.DOM.hr null
			React.DOM.div
				className: 'music-info-box'
				React.DOM.h5
					className: 'music-title'
					'Top Tracks'
				React.DOM.div
					className: 'related'
					for track in @state.toptracks
						React.createElement TrackRow, name: track['name'], length: track['length'], demo: track['demo'], spotify_link: track['spotify_link'], spotify: track['spotify']
			React.DOM.hr null
			React.DOM.div
				className: 'music-info-box'
				React.DOM.h5
					className: 'music-title'
					'Related Artists'
				React.DOM.div
					className: 'music-info-box'
					for artist in @state.related
						React.createElement RelatedArtistBox, name: artist['name'], picture: artist['picture']
			React.DOM.hr null



