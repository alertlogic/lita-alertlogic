require 'lita'
# Lita Module
module Lita
  # Plugin type Handler
  module Handlers
    # Alert Logic Incident routes
    class AlertlogicIncidents < Handler
      config :api_auth
      config :lm_api_url
      config :tm_api_url
      config :customer_api_url
      config :incident_api_url
      config :customer_id
      config :http_options, required: false, type: Hash, default: {}

      namespace 'Alertlogic'

      include ::AlertlogicHelper::Api
      include ::AlertlogicHelper::Common
      include ::AlertlogicHelper::Customer
      include ::AlertlogicHelper::Incidents

      # Route definitions
      # Incidents list route
      route(
        /a(?:lertlogic)? incidents( (.+))?/i,
        :incidents_list,
        help: {
          t('help.incidents.syntax') => t('help.incidents.desc')
        }
      )

      # Customer Info Definition
      def incidents_list(response)
        customer = response.match_data[1]
        return response.reply(t('validation.customer_id')) if customer.nil?
        customer_id = process_customer_id(customer.strip)
        response.reply get_incidents(customer_id)
      end
    end
    Lita.register_handler(AlertlogicIncidents)
  end
end
