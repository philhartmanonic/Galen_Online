json.array!(@states) do |state|
  json.extract! state, :id, :name, :p_or_c, :gop_date, :dem_date, :gop_pledged, :gop_unpledged, :dem_pledged, :dem_unpledged
  json.url state_url(state, format: :json)
end
