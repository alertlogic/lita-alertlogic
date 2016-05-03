require 'spec_helper'

describe Lita::Handlers::AlertlogicMonitoring, lita_handler: true do
  it do
    is_expected.to route_command('alertlogic appliance agent counts 123456').to(:agent_counts_by_appliance)
    is_expected.to route_command('alertlogic policies agent counts 123456').to(:agent_counts_by_policy)
    is_expected.to route_command('alertlogic agent ip counts 123456').to(:agent_ip_counts)
  end
end
