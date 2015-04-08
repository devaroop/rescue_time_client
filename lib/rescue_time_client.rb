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
    end

    def get_token_from_code(code)
      @token = @oauth_client.auth_code.get_token(code, 
                                                 redirect_uri: @redirect_uri, 
                                                 headers: {'Authorization' => 'Basic some_password'}
                                                 )
    end


    #sexy
    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^fetch_(.*)$/
        api_endpoint = "/api/oauth/#{$1}"
        params = arguments[0] || {}
        puts "Fetching #{api_endpoint} with params #{params}}"
        resp = @token.get(api_endpoint, params.merge(default_params))
        Response.process(resp)
      else
        super
      end
    end

    private
    
    def default_params
      {format: 'json'}
    end

  end
end
