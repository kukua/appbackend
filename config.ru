require './app'

# Load all modules
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

#scheduler = Rufus::Scheduler.new

#scheduler.every '2d' do
#  forecast_create("24.97", "60.31", "Europe/Helsinki")
#end

run App
