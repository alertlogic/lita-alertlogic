# Alertlogic Helper
module AlertlogicHelper
  # Agents Helper
  module Agents
    # rubocop:disable MethodLength
    def agent_appliance_summary(customer_id)
      data    = []
      reply   = "/code Appliance/Agents counts for customer: #{customer_id} \n"
      headers = [
        'Appliance Name',
        'Appliance IP',
        'Agents Count',
        'Overall Collection Status'
      ]

      params = {
        customer_id: customer_id,
        type:    'monitoring',
        source: 'tmc-appliances'
      }
      assignment_info = parse_json(
        api_call(params)
      )
      assignment_info['sources'].each do |source|
        data << [
          source['source']['name'],
          source['source']['metadata']['local_ipv4'],
          source['source']['agents_count'],
          source['source']['status']['status']
        ]
      end
      reply << build_table(data, headers)
      reply
    end
    # rubocop:enable MethodLength

    # rubocop:disable MethodLength
    def agent_policy_summary(customer_id)
      data    = []
      reply   = "/code Policy/Agents counts for customer: #{customer_id} \n"
      headers = [
        'Policy Name',
        'Policy ID',
        'Agents Count'
      ]

      params = {
        customer_id: customer_id,
        type:    'tm',
        source: 'policies'
      }
      policies = parse_json(api_call(params))['policies']
      policies.each do |policy|
        policy_id   = policy['policy']['id']
        policy_name = policy['policy']['name']
        params = {
          customer_id: customer_id,
          api_type:    'tm',
          source_type: 'protectedhosts'
        }
        base_url = construct_api_url(params)
        url = "#{base_url}?appliance.policy.id=#{policy_id}"
        params = {
          customer_id: customer_id,
          url:         url
        }
        agents_count = parse_json(api_call(params))['total_count']
        data << [
          policy_name,
          policy_id,
          agents_count
        ]
      end
      reply << build_table(data, headers)
      reply
    end
    # rubocop:enable MethodLength

    def agent_ip_summary(customer_id)
      data     = []
      headers  = [
        'IP Count/Agent',
        'Agents Count'
      ]
      reply    = "/code Agents/IP summary for customer: #{customer_id} \n"
      ip_count = []
      summary  = Hash.new 0
      params     = {
        customer_id: customer_id,
        type:    'tm',
        source: 'protectedhosts'
      }
      agents = parse_json(api_call(params))['protectedhosts']
      agents.each do |agent|
        ip_count << agent['protectedhost']['metadata']['local_ipv4'].length unless !agent['protectedhost']['metadata']
      end
      ip_count.each do |count|
        summary[count] += 1
      end
      summary.each do |agents_list, count|
        data << [agents_list, count]
      end
      reply << build_table(data, headers)
      reply
    end
  end
end
