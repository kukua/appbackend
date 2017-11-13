require 'sinatra'
require 'json'
require 'thin'
require 'rack/protection'
require 'securerandom'
require 'digest/md5'
require 'yaml'
require 'couchrest_model'
require 'pry'
require 'net/http'
require 'crack'
require 'rufus-scheduler'
require 'twilio-ruby'

class App < Sinatra::Base
  
  before do
    content_type 'application/json'
  end
  
  configure do
    set :project_name,  "Kukua"
    set :project_url,   "https://www.kukua.cc"
    
    set :protection, :except => :frame_options
  end
  
  #enable :sessions
  
  get '/dbg' do 
    binding.pry
  end
  
  
  post '/api/forecast/create' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    lat = payload['lat'] rescue false
    lon = payload['lon'] rescue false
    timezone = payload['timezone'] rescue false
    if(lat && lon && timezone)
      create_state = forecast_create(lat, lon, timezone) rescue false
      if(create_state)
        response = create_state
      else
        response = '{"state":403, "message": "Unknown error"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
  
  post '/api/forecast/latest' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    lat = payload['lat'] rescue false
    lon = payload['lon'] rescue false
    timezone = payload['timezone'] rescue false
    if(lat && lon && timezone)
      forecast_state = get_latest_forecast(lat, long, timezone) rescue false
      if(forecast_state)
        response = forecast_state
      else
        response = '{"state":403, "message": "Unknown error"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
    
  get '/api/character/list' do
    character_list.to_json
  end
  
  post '/api/character/update' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    user_id = payload['user_id'] rescue false
    character_type = payload['character_type'] rescue false
    hat_type = payload['hat_type'] rescue false
    pants_type = payload['pants_type'] rescue false
    shirt_type = payload['shirt_type'] rescue false
    shoes_type = payload['shoes_type'] rescue false
    accessories_type = payload['accessories_type'] rescue false
    facial_expression = payload['facial_expression'] rescue false
    if(user_id && character_type && hat_type && shirt_type && pants_type && shoes_type && accessories_type && facial_expression)
      update_state = character_update(user_id, character_type, hat_type, shirt_type, pants_type, shoes_type, accessories_type, facial_expression) rescue false
      if(update_state)
        response = '{"state":200, "update": true}'
      else
        response = '{"state":403, "update": false}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
  
  post '/api/sms/request' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    user_id = payload['user_id'] rescue false
    phone_number = payload['phone_number'] rescue false
    message_content = payload['message_content'] rescue false
    if(user_id && phone_number && message_content)
      create_state = sms_create(user_id, phone_number, message_content) rescue false
      if(create_state)
        response = '{"state":200, "id": "' + create_state.to_s + '"}'
      else
        response = '{"state":403, "message": "Unknown error"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
  
  post '/api/sms/send' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    recipient = payload['recipient'] rescue false
    sms_text = payload['sms_text'] rescue false
    if(recipient && sms_text)
      send_state = sms_send(recipient, sms_text) rescue false
      if(send_state)
        response = '{"state":200, "id": "' + send_state.to_s + '"}'
      else
        response = '{"state":403, "message": "Unknown error"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end

  post '/api/user/login' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    email = payload['email'] rescue false
    password = payload['password'] rescue false
    if(email && password)
      login_state = user_login(email, password) rescue false
      response = '{"state":200, "login": ' + login_state.to_s + '}'
      user_data = user_data_email(email)
      if(login_state)
        response = '{"state":200, "login": ' + login_state.to_s + ', "user_id": "' + user_data._id + '", "lat": ' + user_data.location[0].to_s + ', "lon": ' + user_data.location[1].to_s + ', "timezone": "' + user_data.timezone.to_s + '"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
    
  
  post '/api/user/password/reset' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    email = payload['email'] rescue false
    if(email)
      reset_state = user_password_reset(email) rescue false
      if(reset_state)
        response = '{"state":200, "password": "' + reset_state.to_s + '"}'
      else
        response = '{"state":403, "message": "Unknown error"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
  
  post '/api/user/details' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    user_id = payload['user_id'] rescue false
    if(user_id)
      account_data = user_data(user_id) rescue false
      if(account_data)
        account_json = account_data.to_json.gsub(/\{"_id":"\w+",/, '')
        response = '{"state":200, ' + account_json
        response.to_json
      else
        response = '{"state":403, "message": "User not found"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
    
  post '/api/user/create' do
    response = ""
    request.body.rewind
    payload = JSON.parse(request.body.read)
    first_name = payload['first_name'] rescue false
    last_name = payload['last_name'] rescue false
    email = payload['email'] rescue false
    phone_number = payload['phone_number'] rescue false
    password = payload['password'] rescue false
    character_id = payload['character_id'] rescue false
    timezone = payload['timezone'] rescue false
    location = payload['location'] rescue false
    purpose = payload['purpose'] rescue false
    if(first_name && last_name && email && phone_number && password && character_id && timezone && location && purpose)
      create_state = user_create(first_name, last_name, email, phone_number, password, character_id, timezone, location, purpose) rescue false
      if(create_state)
        response = '{"state":200, "id": "' + create_state.to_s + '"}'
      else
        response = '{"state":403, "message": "User exists"}'
      end
    else
      response = '{"state":403, "message": "Missing parameters"}'
    end
    response
  end
  
  not_found do
    redirect 'https://www.kukua.cc'
  end

end
