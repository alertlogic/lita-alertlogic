require 'spec_helper'

describe Lita::Handlers::AlertlogicLogManager, lita_handler: true do
  it do
    is_expected.to route_command('alertlogic lm appliances 123456').to(:lm_appliance_list)
    is_expected.to route_command('alertlogic lm applianceinfo 123456 12345678-9ABC-DEF1-2345-6789ABCDEF12').to(:lm_appliance_info)
    is_expected.to route_command('alertlogic lm policies 123456').to(:lm_policies_list)
    is_expected.to route_command('alertlogic lm sources 123456').to(:lm_sources_list)
    is_expected.to route_command('alertlogic lm hosts 123456').to(:lm_hosts_list)
  end
end
