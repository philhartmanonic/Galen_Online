@MusicInfographic = React.createClass
	getInitialState: ->
		weiner: ''
	render: ->
		React.DOM.div
			className: 'music-infographic'
			React.DOM.div
				className: 'mi-title'
				'Music Makes the Man'
			React.DOM.div
				className: 'mi-subtitle'
				'The Galen Burghardt Story'
			React.DOM.hr null
			for playlist in @props.playlists
				React.createElement PlaylistTop, key: playlist.id, playlist: playlist
