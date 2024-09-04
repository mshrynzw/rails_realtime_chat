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
    Rails.logger.info "Sending request to Back4App with headers: #{headers}"
    response = get('/classes/Message', headers: headers)
    Rails.logger.info "Back4App API Response: #{response.body}"
    Rails.logger.info "Response code: #{response.code}"
    if response.success?
      JSON.parse(response.body)['results'] || []
    else
      Rails.logger.error "Back4App API Error: #{response.body}"
      []
    end
  end

  def self.create_message(content)
    Rails.logger.info "Sending message to Back4App: #{content}" # デバッグ用ログ
    response = post('/classes/Message',
         body: { content: content }.to_json,
         headers: headers
    )
    Rails.logger.info "Back4App Create Message Response: #{response.body}"
    Rails.logger.info "Response code: #{response.code}"
    response
  end
end