require 'httparty'

class Back4App
  include HTTParty
  base_uri 'https://parseapi.back4app.com'

  def self.headers
    {
      'X-Parse-Application-Id' => ENV['BACK4APP_APPLICATION_ID'],
      'X-Parse-REST-API-Key' => ENV['BACK4APP_REST_API_KEY'],
      'Content-Type' => 'application/json'
    }
  end

  def self.get_messages(retries = 3)
    url = "https://parseapi.back4app.com/classes/Message"

    retries.times do |i|
      begin
        Rails.logger.info "Sending request to Back4App with headers: #{headers}"
        response = HTTParty.get(url, headers: headers)
        Rails.logger.info "Back4App API Response: #{response.body}"
        Rails.logger.info "Response code: #{response.code}"
        
        if response.success?
          return JSON.parse(response.body)["results"]
        else
          Rails.logger.error "Back4App API Error: #{response.code} - #{response.body}"
          Rails.logger.error "Full response: #{response.inspect}"
        end
      rescue => e
        Rails.logger.error "Error in Back4App.get_messages: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end

      sleep(1) if i < retries - 1
    end

    []
  end

  def self.create_message(content, retries = 3)
    url = "https://parseapi.back4app.com/classes/Message"
    body = { content: content }.to_json

    retries.times do |i|
      begin
        response = HTTParty.post(url, headers: headers, body: body)
        Rails.logger.info "Back4App API Response: #{response.body}"
        
        if response.success?
          message = JSON.parse(response.body)
          message['content'] = content  # Add content to the response
          return message
        else
          Rails.logger.error "Back4App API Error: #{response.code} - #{response.body}"
        end
      rescue => e
        Rails.logger.error "Error in Back4App.create_message: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end

      sleep(1) if i < retries - 1
    end

    nil
  end

  def self.login(username, password)
    response = post('/login',
                    body: { username: username, password: password }.to_json,
                    headers: headers
    )
    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error "Login failed: #{response.body}"
      nil
    end
  end
end