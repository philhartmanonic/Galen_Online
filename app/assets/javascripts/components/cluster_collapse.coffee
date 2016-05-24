@ClusterCollapse = React.createClass
	getInitialState: ->
		sorted: []
		atts: ['acousticness', 'danceability', 'duration', 'energy', 'instrumentalness', 'liveness', 'loudness', 'speechiness', 'tempo', 'valence']
		expand: false
		noteworthy: []
		dev: []
	componentWillMount: ->
		for att in @state.atts
			@state.sorted.push([att, (@props.details[att] * 100).toFixed(2)])
		@setState sorted: @state.sorted.sort (a, b) ->
			x = a[1]
			y = b[1]
			return y - x
		for att in @state.sorted
			@state.dev.push([att[0], Math.abs(att[1] - 100).toFixed(2), ((att[1] - 100) / Math.abs(att[1] - 100))])
		@setState dev: @state.dev.sort (a, b) ->
			x = a[1]
			y = b[1]
			return y - x
		for top in @state.dev.slice(0, 3)
			if top[2] > 0
				@state.noteworthy.push(top[1].toString() + '% more ' + top[0])
			else
				@state.noteworthy.push(top[1].toString() + '% less ' + top[0])
	handleClick: (e) ->
		e.preventDefault()
		@setState expand: !@state.expand
	expanded: ->
		React.createElement Cluster, tracks: @props.tracks, details: @props.details
	collapsed: ->
		React.DOM.div
			className: 'track-row'
			React.DOM.div
				className: 'play'
				onClick: @handleClick
			React.DOM.div
				className: 'track-name'
				(@props.tracks.length).toString() + ' tracks, ' + @state.noteworthy[0] + ', ' + @state.noteworthy[1] + ', ' + @state.noteworthy[2]
			React.DOM.hr null
	render: ->
		if @state.expand
			@expanded()
		else
			@collapsed()
