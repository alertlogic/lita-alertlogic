require 'spec_helper'

describe Lita::Handlers::AlertlogicThreatManager, lita_handler: true do
  it do
    is_expected.to route_command('alertlogic tm appliances 123456').to(:tm_appliance_list)
    is_expected.to route_command('alertlogic tm applianceinfo 123456 12345678-9ABC-DEF1-2345-6789ABCDEF12').to(:tm_appliance_info)
    is_expected.to route_command('alertlogic tm policies 123456').to(:tm_policies_list)
    is_expected.to route_command('alertlogic tm hosts 123456').to(:tm_hosts_list)
    is_expected.to route_command('alertlogic protectedhosts status 123456').to(:protectedhosts_status)
    is_expected.to route_command('alertlogic protectedhosts list 123456').to(:protectedhosts_list)
    is_expected.to route_command('alertlogic protectedhosts search 123456 phostname-or-uuid').to(:protectedhosts_search)
  end
end
