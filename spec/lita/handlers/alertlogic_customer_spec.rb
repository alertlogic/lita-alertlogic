require 'spec_helper'

describe Lita::Handlers::AlertlogicCustomer, lita_handler: true do
  it do
    is_expected.to route_command('alertlogic customerinfo 123456').to(:customer_info)
  end
end
