class Settings < Settingslogic
  source Rails.root.join("config").join("application.yml")
  namespace Rails.env
end
