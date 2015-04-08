require 'auth/oauth'
require 'response.rb'

module RescueTime
  API_ENDPOINT = "https://www.rescuetime.com"
  DEFAULT_SCOPE = ["time_data"]

  class Client
    def initialize(client_id, client_secret, redirect_uri)
      @oauth_client = Auth.getClient(client_id, client_secret)
      @redirect_uri = redirect_uri
    end

    def get_auth_url(scopes = [])
      scopes = DEFAULT_SCOPE if scopes.empty?
      required_scopes = scopes.join(' ')
      @oauth_client.auth_code.authorize_url(redirect_uri: @redirect_uri, 
                                            scope: required_scopes)
    end

    def set_token(token)
      @token = Auth.constructToken(@oauth_client, token)

      @token
    end

    def get_token_from_code(code)
      @token = @oauth_client.auth_code.get_token(code, 
                                                 redirect_uri: @redirect_uri, 
                                                 headers: {'Authorization' => 'Basic some_password'}
                                                 )

      @token
    end

    def get_daily_summary_feed(params = {})
      resp = @token.get('/api/oauth/daily_summary_feed', params)
      Response.process(resp)
    end

    def get_data(params = {})
      resp = @token.get('/api/oauth/data', params)
      Response.process(resp)
    end

  end
end
