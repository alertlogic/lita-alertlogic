# Alertlogic Helper
module AlertlogicHelper
  # Log Manager Helper
  module LogManager
    # rubocop:disable MethodLength
    # rubocop:disable Metrics/AbcSize
    def process_lm_hosts(customer_id, hosts)
      headers    = [
        'Host Name',
        'Host Type',
        'Host ID',
        'IP Address',
        'Host Status'
      ]
      data       = []
      tables     = []
      hosts_list = hosts['hosts']
      reply_head = "/code Log Hosts for customer: #{customer_id} \n"

      hosts_list.each do |host|
        if !host['host']['metadata'].nil?
          ipv4 = host['host']['metadata']['local_ipv4']
        else
          ipv4 = ''
        end
        data << [
          host['host']['name'],
          host['host']['type'],
          host['host']['id'],
          ipv4,
          host['host']['status']['status']
        ]
        if check_msg_size?(build_table(data, headers))
          tables << [data, headers]
          data = []
        end
      end

      summary = "\nTotal Sources: #{hosts['total_count']}"
      if tables.length > 0
        reply = [reply_head, tables, summary]
        return reply
      else
        reply = reply_head
        reply << build_table(data, headers)
        reply << summary
        return reply
      end
    end
    # rubocop:enable MethodLength
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable MethodLength
    def process_lm_sources(customer_id, sources)
      headers      = [
        'Source Name',
        'Source Type',
        'IP Address',
        'Source ID',
        'Source Status'
      ]
      data         = []
      tables       = []
      sources_list = sources['sources']
      reply_head   = "/code Log Sources for customer: #{customer_id} \n"

      sources_list.each do |source|
        source.each do |type, info|
          data << [
            info['name'],
            type,
            info['metadata']['local_ipv4'],
            info['id'],
            info['status']['status']
          ]
          if check_msg_size?(build_table(data, headers))
            tables << [data, headers]
            data = []
          end
        end
      end

      summary = "\nTotal Sources: #{sources['total_count']}"
      if tables.length > 0
        reply = [reply_head, tables, summary]
        return reply
      else
        reply = reply_head
        reply << build_table(data, headers)
        reply << summary
        return reply
      end
    end
    # rubocop:enable MethodLength

    def process_lm_policies(customer_id, policies)
      headers     = [
        'Policy Type',
        'Policy Name',
        'Policy ID'
      ]
      data        = []
      policy_list = policies['policies']
      reply       = "/code Log Policies for customer: #{customer_id} \n"

      policy_list.each do |policy|
        policy.each do |type, info|
          data << [
            type,
            info['id'],
            info['name']
          ]
        end
      end

      reply << build_table(data, headers)
      reply << "\nTotal Policies: #{policies['total_count']}"
      reply
    end
  end
end
