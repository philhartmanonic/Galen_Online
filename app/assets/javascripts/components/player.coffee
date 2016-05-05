@Player = React.createClass
	getInitialState: ->
		autoplay: true
	render: ->
		React.DOM.div
			className: 'player-box'
			React.DOM.iframe
				className: 'audio'
				src: 'https://embed.spotify.com/?uri=' + @props.spotify
				width: (screen.width / 5)
				height: 80