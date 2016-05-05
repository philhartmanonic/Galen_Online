@Bands = React.createClass
	getInitialState: ->
		weiner: ''
	render: ->
		React.DOM.div
			className: 'row'
			React.DOM.hr null
			React.DOM.h5
				className: 'music-title'
				"Who I've Been Listening to Lately"
			React.DOM.hr null
			for band in @props.recent_bands
				React.createElement Band, id: band.id, name: band.name, picture: band.picture, picture2: band.picture2, popularity: band.popularity, genres: band.genres
			React.DOM.hr null
			React.DOM.h5
				className: 'music-title'
				"All-time Favorites"
			for band in @props.all_bands
				React.createElement Band, id: band.id, name: band.name, picture: band.picture, picture2: band.picture2, popularity: band.popularity, genres: band.genres
			React.DOM.hr null