require 'lita'
# Lita Module
module Lita
  # Plugin type Handler
  module Handlers
    # Alert Logic Log Manager Routes
    class AlertlogicLogManager < Handler
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
      include ::AlertlogicHelper::Appliances
      include ::AlertlogicHelper::LogManager

      # LM appliance routes
      route(
        /a(?:lertlogic)? lm appliances( (.+))?/i,
        :lm_appliance_list,
        help: {
          t('help.lm.appliances.syntax') => t('help.lm.appliances.desc')
        }
      )
      route(
        /a(?:lertlogic)? lm applianceinfo? (.+)? (.+)?/i,
        :lm_appliance_info,
        help: {
          t('help.lm.applianceinfo.syntax') => t('help.lm.applianceinfo.desc')
        }
      )

      # Log Policies route
      route(
        /a(?:lertlogic)? lm policies? (.+)?/i,
        :lm_policies_list,
        help: {
          t('help.lm.policies.syntax') => t('help.lm.policies.desc')
        }
      )

      # Log Sources route
      route(
        /a(?:lertlogic)? lm sources? (.+)?/i,
        :lm_sources_list,
        help: {
          t('help.lm.sources.syntax') => t('help.lm.sources.desc')
        }
      )

      # Log Hosts route
      route(
        /a(?:lertlogic)? lm hosts? (.+)?/i,
        :lm_hosts_list,
        help: {
          t('help.lm.hosts.syntax') => t('help.lm.hosts.desc')
        }
      )

      # LM Data Definitions
      def lm_appliance_list(response)
        customer_id   = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        appliance_list = []
        customers      = get_customer_ids(customer_id)
        return response.reply(customers) unless customers.is_a? Array
        response.reply(t('warn.standby'))

        customers.each do |cid|
          params = {
            customer_id: cid,
            type:        'lm',
            source:      'appliances'
          }
          resp = api_call(params)
          appliance_list << process_appliances(resp, cid)
        end

        reply_text = appliance_list
        response.reply(reply_text)
      end

      def lm_appliance_info(response)
        customer_id = valid_cid(response.match_data[1])
        uuid        = response.match_data[2]
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        return response.reply(t('validation.uuid')) if uuid.nil?

        url_params  = {
          customer_id: customer_id,
          api_type:    'lm',
          source_type: 'appliances'
        }

        url    = construct_api_url(url_params)
        url    = "#{url}/#{uuid}"
        params = {
          customer_id: customer_id,
          url:         url
        }

        appliance_info = pretty_json(
          parse_json(
            api_call(params)
          )
        )

        reply_text = "/code #{appliance_info}"
        response.reply(reply_text)
      end

      def lm_hosts_list(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        params = {
          customer_id: customer_id,
          type:        'lm',
          source:      'hosts'
        }
        resp = parse_json(
          api_call(params)
        )

        reply_text = process_lm_hosts(customer_id, resp)
        if reply_text.length == 3
          head = reply_text[0]
          tables = reply_text[1]
          summary = reply_text[2]
          response.reply(head)
          tables.each do |data, headers|
            response.reply("/code #{build_table(data, headers)}")
          end
          response.reply(summary)
        else
          response.reply(reply_text)
        end
      end

      def lm_policies_list(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        params = {
          customer_id: customer_id,
          type:        'lm',
          source:      'policies'
        }
        resp = parse_json(
          api_call(params)
        )

        reply_text = process_lm_policies(customer_id, resp)
        response.reply(reply_text)
      end

      def lm_sources_list(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        params = {
          customer_id: customer_id,
          type:        'lm',
          source:      'sources'
        }
        resp = parse_json(
          api_call(params)
        )

        reply_text = process_lm_sources(customer_id, resp)
        if reply_text.length == 3
          head = reply_text[0]
          tables = reply_text[1]
          summary = reply_text[2]
          response.reply(head)
          tables.each do |data, headers|
            response.reply("/code #{build_table(data, headers)}")
          end
          response.reply(summary)
        else
          response.reply(reply_text)
        end
      end
    end
    Lita.register_handler(AlertlogicLogManager)
  end
end
