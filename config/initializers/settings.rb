# one class per a yml file
class Settings < Settingslogic
  source Rails.root.join("config").join("application.yml")
  namespace Rails.env
end

class WeatherSettings < Settingslogic
  source Rails.root.join("config").join("weather_settings.yml")
  namespace Rails.env
end
