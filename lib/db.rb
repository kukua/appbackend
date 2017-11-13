class User < CouchRest::Model::Base
  use_database 'users'
  property :_id,                String
  property :first_name,         String
  property :last_name,          String
  property :email,              String
  property :phone_number,       String
  property :password,           String
  property :character_id,       String
  property :timezone,           String
  property :location,           Array
  property :purpose,            String

  timestamps!

  design do
    view :by_email
    view :by_id,
      :map =>
        "function(doc) {
          emit(doc._id, doc);
        }"
    view :by_date,
      :map =>
        "function(doc) {
          emit(doc.created_at, doc);
        }"
  end
end

class ForecastData < CouchRest::Model::Base
  use_database 'forecast_data'
  property :_id,                    String
  property :lat,                    Float
  property :lon,                    Float
  property :timezone,               String
  property :forecast,               Hash

  timestamps!

  design do
    view :by_id,
      :map =>
        "function(doc) {
          emit(doc._id, doc);
        }"
    view :by_lat_and_lon_and_timezone,
      :map =>
        "function (doc) {
           if (doc.lat && doc.lon && doc.timezone && doc.created_at) {
             emit([doc.lat, doc.lon, doc.timezone, doc.created_at], doc);
           }
         }"
    view :by_date,
      :map =>
        "function(doc) {
          emit(doc.created_at, doc);
        }"
  end
end

class Forecast < CouchRest::Model::Base
  use_database 'forecasts'
  property :_id,                    String
  property :user_id,                String 
  property :location,               String
  property :basic_description,      String
  property :cloud_type,             String
  property :temperature,            String
  property :rain_chance,            String
  property :wind_speed,             String
  property :wind_direction,         String
  property :humidity,               String
  property :pressure,               String

  timestamps!

  design do
    view :by_user_id
    view :by_id,
      :map =>
        "function(doc) {
          emit(doc._id, doc);
        }"
    view :by_date,
      :map =>
        "function(doc) {
          emit(doc.created_at, doc);
        }"
  end
end

class SMS < CouchRest::Model::Base
  use_database 'sms'
  property :_id,                    String
  property :user_id,                String 
  property :phone_number,           String
  property :message_content,        String

  timestamps!

  design do
    view :by_user_id
    view :by_id,
      :map =>
        "function(doc) {
          emit(doc._id, doc);
        }"
    view :by_date,
      :map =>
        "function(doc) {
          emit(doc.created_at, doc);
        }"
  end
end

class Character < CouchRest::Model::Base
  use_database 'characters'
  property :_id,                String
  property :user_id,            String 
  property :character_type,     String
  property :hat_type,           String
  property :shirt_type,         String
  property :pants_type,         String
  property :shoes_type,         String
  property :accessories_type,   String
  property :facial_expression,  String

  timestamps!

  design do
    view :by_user_id,
      :map =>
        "function(doc) {
          emit(doc.user_id, doc);
        }"
    view :by_id,
      :map =>
        "function(doc) {
          emit(doc._id, doc);
        }"
    view :by_date,
      :map =>
        "function(doc) {
          emit(doc.created_at, doc);
        }"
  end
end


# Create databases

User.new().new?
Forecast.new().new?
SMS.new().new?
Character.new().new?
