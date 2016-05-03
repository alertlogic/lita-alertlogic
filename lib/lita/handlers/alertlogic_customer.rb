require 'lita'
# Lita Module
module Lita
  # Plugin type Handler
  module Handlers
    # Alert Logic Customer Routes
    class AlertlogicCustomer < Handler
      config :api_auth
      config :customer_api_url
      config :customer_id
      config :http_options, required: false, type: Hash, default: {}

      namespace 'Alertlogic'

      include ::AlertlogicHelper::Api
      include ::AlertlogicHelper::Common
      include ::AlertlogicHelper::Customer

      # Route definitions
      # Customer info route
      route(
        /a(?:lertlogic)? customerinfo( (.+))?/i,
        :customer_info,
        help: {
          t('help.customerinfo.syntax') => t('help.customerinfo.desc')
        }
      )

      # Customer Info Definition
      def customer_info(response)
        customer = response.match_data[1]
        return response.reply(t('validation.customer_id')) if customer.nil?
        response.reply(t('warn.standby'))

        customers   = []
        customer_id = process_customer_id(customer.strip)

        if customer_id.is_a? Array
          customer_id.each do |cid|
            params = {
              customer_id: cid,
              type:        'customer'
            }
            customers << api_call(params)
          end
        else
          params = {
            customer_id: customer_id,
            type:        'customer'
          }
          customers = api_call(params)
        end

        reply_text = process_customers(customers)
        response.reply(reply_text.to_s)
      end
    end
    Lita.register_handler(AlertlogicCustomer)
  end
end
