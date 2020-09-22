require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class HubSpot < OmniAuth::Strategies::OAuth2
      option :name, "hubspot"

      args [:client_id, :client_secret]

      option :client_options, {
        site: 'https://api.hubapi.com',
        authorize_url: 'https://app.hubspot.com/oauth/authorize',
        token_url: 'oauth/v1/token'
      }

      uid{ raw_info['user_id'] }

      info do
        {
            :email => raw_info['user'],
            :hub_id => raw_info['hub_id'],
            :hub_domain => raw_info['hub_domain'],
            :app_id => raw_info['app_id']
        }
      end

      def raw_info
        @raw_info ||= access_token.get("https://api.hubapi.com/oauth/v1/access-tokens/#{access_token.token}").parsed
      end

      # hubspot doesnt like it when the query params are also passed because it breaks redirect url matching
      def callback_url
        full_host + script_name + callback_path
      end

    end
  end
end

OmniAuth.config.add_camelization 'hubspot', 'HubSpot'
