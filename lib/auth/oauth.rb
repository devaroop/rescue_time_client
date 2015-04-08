require 'oauth2'

module RescueTime
  module Auth

    def getClient(client_id, client_secret)
      OAuth2::Client.new(client_id, client_secret, :site => API_ENDPOINT)
    end

    def constructToken(client, token)
      Oauth2::AccessToken.new(client, token)
    end

  end
end
