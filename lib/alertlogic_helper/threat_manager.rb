# Alertlogic Helper
module AlertlogicHelper
  # Threat Manager Helper
  module ThreatManager
    # rubocop:disable MethodLength
    # rubocop:disable Metrics/AbcSize
    def process_tm_policies(customer_id, policies)
      headers = [
        'Policy ID',
        'Name',
        'Appliance Assignment',
        'Type'
      ]
      data    = []
      tables  = []
      reply_head   = "/code Threat Policies for customer: #{customer_id} \n"

      policies['policies'].each do |policy|
        data << [
          policy['policy']['id'],
          policy['policy']['name'],
          !policy['policy']['appliance_assignment'].nil? ? policy['policy']['appliance_assignment']['appliances'].join(',') : nil,
          policy['policy']['type']
        ]
        if check_msg_size?(build_table(data, headers))
          tables << [data, headers]
          data = []
        end
      end

      summary =  "\nTotal Policies: #{policies['total_count']}"
      if tables.length > 0
        reply = [reply_head, tables, summary]
        return reply
      else
        reply = reply_head
        reply << build_table(data, headers)
        reply << summary
      end
    end
    # rubocop:enable MethodLength
    # rubocop:enable Metrics/AbcSize

    # rubocop:disable MethodLength
    # rubocop:disable Metrics/AbcSize
    def process_tm_hosts(customer_id, hosts)
      headers = [
        'Host Name',
        'Host ID',
        'Type',
        'IP Address',
        'Status'
      ]
      data    = []
      tables  = []
      reply_head   = "/code Threat Hosts for customer: #{customer_id} \n"

      hosts['hosts'].each do |host|
        if !host['host']['metadata'].nil?
          ipv4 = host['host']['metadata']['local_ipv4']
        else
          ipv4 = ''
        end
        data << [
          host['host']['name'],
          host['host']['id'],
          host['host']['type'],
          ipv4,
          host['host']['status']['status']
        ]
        if check_msg_size?(build_table(data, headers))
          tables << [data, headers]
          data = []
        end
      end

      summary = "\nTotal Hosts: #{hosts['total_count']}"
      if tables.length > 0
        reply = [reply_head, tables, summary]
        return reply
      else
        reply = reply_head
        reply << build_table(data, headers)
        reply << summary
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable MethodLength

    # rubocop:disable Metrics/AbcSize
    def process_protectedhosts(customer_id, phosts)
      phost_list = phosts['protectedhosts']
      reply      = "/code Protectedhosts Status for customer: #{customer_id} \n"
      ok         = 0
      error      = 0
      new        = 0
      offline    = 0
      total      = 0
      other      = 0
      headers    = %w(OK Error New Offline Unknown)
      data       = []

      phost_list.each do |phost|
        status = phost['protectedhost']['status']['status'].strip
        ok += 1 if status == 'ok'
        error += 1 if status == 'error'
        new += 1 if status == 'new'
        offline += 1 if status == 'offline'
        other += 1 unless %w(ok error new offline).include? status
        total += 1
      end

      data << [ok, error, new, offline, other]
      reply << build_table(data, headers)
      reply << "\nTotal Protected Hosts: #{total}"
    end
    # rubocop:enable Metrics/AbcSize

    def search_phost_by_name(key, search_term, phosts)
      phosts['protectedhosts'].each do |phost|
        if search?(key, search_term, phost['protectedhost'])
          return JSON.pretty_generate(phost['protectedhost'])
        end
      end
    end

    # rubocop:disable MethodLength
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/PerceivedComplexity
    def process_protectedhosts_list(customer_id, phosts)
      phost_list = phosts['protectedhosts']
      reply_head = "/code Protectedhosts Status for customer: #{customer_id} \n"
      headers    = %w(Name VPC Status)
      data   = []
      tables = []
      total  = 0
      phost_list.each do |phost|
        total += 1
        if phost['protectedhost'].key?('metadata')
          if phost['protectedhost']['metadata'].key?('ec2_vpc')
            vpc = phost['protectedhost']['metadata']['ec2_vpc'].join(',')
          else
            vpc = 'No VPC found'
          end
        else
          vpc = 'No metadata was found'
        end
        data << [
          phost['protectedhost']['name'].strip,
          vpc,
          phost['protectedhost']['status']['status'].strip
        ]
        if check_msg_size?(build_table(data, headers))
          tables << [data, headers]
          data = []
        end
      end

      summary = "/code Total Protected Hosts: #{total}"
      if tables.length > 0
        reply = [reply_head, tables, summary]
        reply
      else
        reply = reply_head
        reply << build_table(data, headers)
        reply << summary
      end
    end
    # rubocop:enable MethodLength
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/PerceivedComplexity
  end
end
