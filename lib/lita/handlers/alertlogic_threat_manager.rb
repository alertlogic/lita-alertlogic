require 'lita'
# Lita Module
module Lita
  # Plugin type Handler
  module Handlers
    # Alert Logic Threat Manager Routes
    class AlertlogicThreatManager < Handler
      config :api_auth
      config :lm_api_url
      config :tm_api_url
      config :customer_api_url
      config :incident_api_url
      config :monitoring_api_url
      config :customer_id
      config :http_options, required: false, type: Hash, default: {}

      namespace 'Alertlogic'

      include ::AlertlogicHelper::Api
      include ::AlertlogicHelper::Common
      include ::AlertlogicHelper::Customer
      include ::AlertlogicHelper::Appliances
      include ::AlertlogicHelper::ThreatManager

      # TM appliance routes
      route(
        /a(?:lertlogic)? tm appliances( (.+))?/i,
        :tm_appliance_list,
        help: {
          t('help.tm.appliances.syntax') => t('help.tm.appliances.desc')
        }
      )
      route(
        /a(?:lertlogic)? tm applianceinfo? (.+)? (.+)?/i,
        :tm_appliance_info,
        help: {
          t('help.tm.applianceinfo.syntax') => t('help.tm.applianceinfo.desc')
        }
      )

      # Threat Policies route
      route(
        /a(?:lertlogic)? tm policies? (.+)?/i,
        :tm_policies_list,
        help: {
          t('help.tm.policies.syntax') => t('help.tm.policies.desc')
        }
      )

      # Threat hosts route
      route(
        /a(?:lertlogic)? tm hosts? (.+)?/i,
        :tm_hosts_list,
        help: {
          t('help.tm.hosts.syntax') => t('help.tm.hosts.desc')
        }
      )

      # Threat Protected hosts route
      route(
        /a(?:lertlogic)? protectedhosts status( (.+))?/i,
        :protectedhosts_status,
        help: {
          t('help.tm.protectedhosts.status.syntax') => t('help.tm.protectedhosts.status.desc')
        }
      )

      route(
        /a(?:lertlogic)? protectedhosts list( (.+))?/i,
        :protectedhosts_list,
        help: {
          t('help.tm.protectedhosts.list.syntax') => t('help.tm.protectedhosts.list.desc')
        }
      )

      route(
        /a(?:lertlogic)? protectedhosts search? (.+)? (.+)?/i,
        :protectedhosts_search,
        help: {
          t('help.tm.protectedhosts.search.syntax') => t('help.tm.protectedhosts.search.desc')
        }
      )

      # TM Data Definitions
      def tm_appliance_info(response)
        customer_id = valid_cid(response.match_data[1])
        uuid = response.match_data[2]
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        return response.reply(t('validation.uuid')) if uuid.nil?
        response.reply(t('warn.standby'))

        url_params = {
          customer_id: customer_id,
          api_type:    'tm',
          source_type: 'appliances'
        }
        url = construct_api_url(url_params)
        url = "#{url}/#{uuid}"

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

      def tm_appliance_list(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        appliance_list = []
        customers = get_customer_ids(customer_id)
        return response.reply(customers) unless customers.is_a? Array
        response.reply(t('warn.standby'))

        customers.each do |cid|
          params = {
            customer_id: cid,
            type:        'tm',
            source:      'appliances'
          }
          resp = api_call(params)
          appliance_list << process_appliances(resp, cid)
        end

        reply_text = appliance_list
        response.reply(reply_text)
      end

      def tm_hosts_list(response)
        customer_id = valid_cid(response.match_data[1])
        response.reply(t('warn.standby'))

        params = {
          customer_id: customer_id,
          type:        'tm',
          source:      'hosts'
        }
        resp = parse_json(
          api_call(params)
        )

        reply_text = process_tm_hosts(customer_id, resp)
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

      def tm_policies_list(response)
        customer_id = valid_cid(response.match_data[1])
        response.reply(t('warn.standby'))

        params = {
          customer_id: customer_id,
          type:        'tm',
          source:      'policies'
        }
        resp = parse_json(
          api_call(params)
        )

        reply_text = process_tm_policies(customer_id, resp)
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

      def protectedhosts_list(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        params = {
          customer_id: customer_id,
          type: 'tm',
          source: 'protectedhosts'
        }
        resp = parse_json(api_call(params))

        reply_text = process_protectedhosts_list(customer_id, resp)
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

      def protectedhosts_status(response)
        customer_id = valid_cid(response.match_data[1])
        response.reply(t('warn.standby'))

        params = {
          customer_id: customer_id,
          type: 'tm',
          source: 'protectedhosts'
        }
        resp = parse_json(api_call(params))
        return response.reply(t('validation.customer_id')) if customer_id.nil?

        if resp['total_count'] == 0
          reply_text = pretty_json(resp)
          response.reply("/code #{reply_text}")
        else
          reply_text = process_protectedhosts(customer_id, resp)
          response.reply(reply_text)
        end
      end

      def protectedhosts_search(response)
        customer_id = valid_cid(response.match_data[1])
        term = response.match_data[2]
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        if valid_uuid?(term)
          key = 'id'
        else
          key = 'name'
        end
        params = {
          customer_id: customer_id,
          type: 'tm',
          source: 'protectedhosts'
        }
        resp = parse_json(api_call(params))

        reply_text = search_phost_by_name(key, term, resp)
        response.reply("/code #{reply_text}")
      end
    end
    Lita.register_handler(AlertlogicThreatManager)
  end
end
