@RelatedArtistBox = React.createClass
	getInitialState: ->
		extra: false	
	render: ->
		React.DOM.div
			className: 'related-artist-box'
			React.DOM.div
				className: 'related-artist'
				style: {backgroundImage: 'url(' + @props.picture + ')', backgroundSize: 'cover', backgroundPosition: 'center', minWidth: (screen.width / 12), height: (screen.width / 14)}
				React.DOM.div
					className: 'related-artist-name'
					style: {marginTop: ((screen.width / 12) / 10), marginBottom: ((screen.width / 12) / 10), marginRight: ((screen.width / 18) / 10), marginLeft: ((screen.width / 18) / 10), padding: ((screen.width / 18) / 10), maxWidth: ((screen.width / 12) * .95)}
					@props.name