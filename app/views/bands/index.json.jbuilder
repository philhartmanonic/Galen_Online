json.array!(@bands) do |band|
  json.extract! band, :id, :name, :fb_id, :fb_name, :likes_count, :ta_count, :pic_url, :follower_count, :following_count, :tweets
  json.url band_url(band, format: :json)
end
