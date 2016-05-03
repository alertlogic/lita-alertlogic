require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'alertlogic_helper/api'
require 'alertlogic_helper/agents'
require 'alertlogic_helper/common'
require 'alertlogic_helper/customer'
require 'alertlogic_helper/incidents'
require 'alertlogic_helper/appliances'
require 'alertlogic_helper/log_manager'
require 'alertlogic_helper/threat_manager'

require 'lita/handlers/alertlogic_customer'
require 'lita/handlers/alertlogic_incidents'
require 'lita/handlers/alertlogic_monitoring'
require 'lita/handlers/alertlogic_log_manager'
require 'lita/handlers/alertlogic_threat_manager'
