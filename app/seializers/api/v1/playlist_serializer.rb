class Api::V1::PlaylistSerializer < Api::V1::BaseSerializer
	attributes :id, :tracks
	require 'json'

	def tracks
		json_tracks = object.tracks.to_json(:include => {:artists => {:include => :genres}})
		return JSON.parse(json_tracks)
	end
end