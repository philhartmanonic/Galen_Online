class Api::V1::PlaylistsController < Api::V1::BaseController
	def show
		playlist = Playlist.find(params[:id])
		render(json: Api::V1::PlaylistSerializer.new(playlist).to_json)
	end

	def clusters
		playlist = Playlist.find(params[:playlist_id])
		render(json: Api::V1::PlaylistClusterSerializer.new(playlist).to_json)
	end
end