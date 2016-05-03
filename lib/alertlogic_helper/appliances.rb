# Alertlogic Helper
module AlertlogicHelper
  # Appliances Helper
  module Appliances
    def process_appliances(appliance_list, customer_id)
      data    = []
      reply   = "/code Customer appliances for ID: #{customer_id} \n"
      headers = ['Appliance Type', 'UUID', 'Name', 'Status']

      parse_json(appliance_list)['appliances'].each do |appliance|
        appliance.each do |type, details|
          data << [
            type,
            details['id'],
            details['name'],
            details['status']['status']
          ]
        end
      end

      count = parse_json(appliance_list)['total_count']
      reply << build_table(data, headers)
      reply << "Total Appliances: #{count}\n"
      reply
    end
  end
end
