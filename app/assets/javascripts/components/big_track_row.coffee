@BigTrackRow = React.createClass
	getInitialState: ->
		play: false
	makeTime: (ms) ->
		minutes = (ms/1000/60) << 0
		seconds = (ms/1000) % 60 << 0
		if seconds > 9
			return String(minutes) + ":" + String(seconds)
		else
			return String(minutes) + ":0" + String(seconds)
	handleClick: (e) ->
		e.preventDefault()
		@setState play: !@state.play
	render: ->
		React.DOM.div
			className: 'track-row'
			React.DOM.div
				className: 'play'
				onClick: @handleClick
			React.DOM.div
				className: 'track-name'
				@props.name
			React.DOM.div
				className: 'track-artist-names'
				for artist in @props.artists
					React.DOM.div
						className: 'track-artist-name'
						artist.name
			React.DOM.div
				className: 'track-time'
				@makeTime(@props.length)
			React.DOM.hr null
			if @state.play
				React.createElement Player, key: 'player-' + @props.name, name: @props.name, duration: @makeTime(@props.length), demo: @props.demo, spotify_link: @props.spotify_link, spotify: @props.spotify