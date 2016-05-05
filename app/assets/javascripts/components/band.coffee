@Band = React.createClass
	getInitialState: ->
		moreInfo: false
		related: []
		toptracks: []
	handleClick: (e) ->
		e.preventDefault()
		@setState moreInfo: !@state.moreInfo
	render: ->
		React.DOM.div
			className: 'band'
			style: {marginBottom: (screen.height / 50)}
			React.DOM.div
				className: 'band-image'
				onClick: @handleClick
				style: {backgroundImage: 'url(' + @props.picture + ')', backgroundSize: 'cover', backgroundPosition: 'center', minHeight: (screen.height / 10)}
			React.DOM.div
				className: 'band-info'
				onClick: @handleClick
				React.DOM.div
					className: 'band-name'
					@props.name
				React.DOM.div
					className: 'band-popularity'
					"Popularity: " + @props.popularity
				React.DOM.div
					className: 'band-popularity'
					"(Click for more)"
			React.DOM.hr null
			if @state.moreInfo
				React.createElement ArtistInfo, id: @props.id, name: @props.name, background: @props.picture2