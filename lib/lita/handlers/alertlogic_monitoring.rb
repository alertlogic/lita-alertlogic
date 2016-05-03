require 'lita'
# Lita Module
module Lita
  # Plugin type Handler
  module Handlers
    # Alert Logic Monitoring routes
    class AlertlogicMonitoring < Handler
      config :api_auth
      config :tm_api_url
      config :monitoring_api_url
      config :customer_id
      config :http_options, required: false, type: Hash, default: {}

      namespace 'Alertlogic'

      include ::AlertlogicHelper::Api
      include ::AlertlogicHelper::Common
      include ::AlertlogicHelper::Customer
      include ::AlertlogicHelper::Agents

      # Monitoring routes
      route(
        /a(?:lertlogic)? appliance agent counts( (.+))?/i,
        :agent_counts_by_appliance,
        help: {
          t('help.monitoring.appliance_agent_counts.syntax') => t('help.monitoring.appliance_agent_counts.desc')
        }
      )
      route(
        /a(?:lertlogic)? policies agent counts( (.+))?/i,
        :agent_counts_by_policy,
        help: {
          t('help.monitoring.policy_agent_counts.syntax') => t('help.monitoring.policy_agent_counts.desc')
        }
      )
      route(
        /a(?:lertlogic)? agent ip counts( (.+))?/i,
        :agent_ip_counts,
        help: {
          t('help.monitoring.agent_ip_counts.syntax') => t('help.monitoring.agent_ip_counts.desc')
        }
      )

      def agent_counts_by_appliance(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        agent_info = agent_appliance_summary(customer_id)

        reply_text = agent_info
        response.reply(reply_text)
      end

      def agent_counts_by_policy(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        agent_info = agent_policy_summary(customer_id)

        reply_text = agent_info
        response.reply(reply_text)
      end

      def agent_ip_counts(response)
        customer_id = valid_cid(response.match_data[1])
        return response.reply(t('validation.customer_id')) if customer_id.nil?
        response.reply(t('warn.standby'))

        agent_info = agent_ip_summary(customer_id)

        reply_text = agent_info
        response.reply(reply_text)
      end
    end
    Lita.register_handler(AlertlogicMonitoring)
  end
end
