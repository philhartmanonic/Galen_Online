class Api::V1::PlaylistClusterSerializer < Api::V1::PlaylistSerializer
	attributes :clusters
	require 'json'

	def clusters
		json_clusters = object.to_json(:methods => :clusters)
		return JSON.parse(json_clusters)
	end
end