require 'httparty'
require 'rails'

module Back4App
  include HTTParty
  base_uri 'https://parseapi.back4app.com'

  def self.headers
    {
      'X-Parse-Application-Id' => ENV['BACK4APP_APPLICATION_ID'],
      'X-Parse-REST-API-Key' => ENV['BACK4APP_REST_API_KEY'],
      'Content-Type' => 'application/json'
    }
  end

  def self.get_messages
    response = get('/classes/Message', headers: headers)
    Rails.logger.info "Back4App API Response: #{response.body}"
    JSON.parse(response.body)['results'] || []
  end

  def self.create_message(content)
    post('/classes/Message',
         body: { content: content }.to_json,
         headers: headers
    )
  end
end