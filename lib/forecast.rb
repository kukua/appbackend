def forecast_create(lat, lon, timezone)
  lat = lat.to_f rescue 0.0
  lon = lon.to_f rescue 0.0
  forecast_state = ForecastData.new(:lat => lat, :lon => lon, :timezone => timezone, :forecast => Crack::XML.parse(Net::HTTP.get_response(URI.parse("http://fnw2.foreca.com/showdata.php?lon=#{lon}&lat=#{lat}&ftimes=48/3h&tz=#{timezone}&format=xml/kukua-jun18t")).body).to_hash).save
  if(forecast_state)
    forecast_state = forecast_state.to_json rescue false
  end
  forecast_state
end

def get_latest_forecast(lat, long, timezone)
  ForecastData.by_lat_and_lon_and_timezone(:startkey => [lat, long, timezone, '1900-11-05T20:16:28.219Z'], :endkey => [lat, long, timezone, '3000-11-05T20:16:28.219Z']).last.to_json
end