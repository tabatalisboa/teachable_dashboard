class Teachable::Client
  BASE = ENV.fetch("TEACHABLE_API_BASE", "https://developers.teachable.com")
  LOGGER = defined?(Rails) && Rails.logger ? Rails.logger : Logger.new($stdout)

  def initialize(api_key:ENV.fetch("TEACHABLE_API_KEY"))
    @api_key = api_key
    @conn = Faraday.new(url: BASE) do |f|
      f.response :json, content_type:: /\bjson$/
      f.response :logger, LOGGER, bodies: false
      f.adapter Faraday.default_adapter
    end
    
  end
  
end