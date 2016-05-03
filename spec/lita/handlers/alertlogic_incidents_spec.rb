require 'spec_helper'

describe Lita::Handlers::AlertlogicIncidents, lita_handler: true do
  it do
    is_expected.to route_command('alertlogic incidents 123456').to(:incidents_list)
  end
end
