# lita-alertlogic

[![Build Status](https://api.travis-ci.org/alertlogic/lita-alertlogic.svg?branch=master)](https://travis-ci.org/alertlogic/lita-alertlogic)

**lita-alertlogic** is a handler for [Lita](https://github.com/jimmycuadra/lita). It can be used to pull various data points about Alert Logic customers directly from Hipchat.

## Installation

Add lita-alertlogic to your Lita instance's Gemfile:

``` ruby
gem 'lita-alertlogic'
```

## Usage

Run 'lita help alertlogic' to get detailed usage:

```
 [You] lita help alertlogic
[Lita Bot] 
Lita: alertlogic customerinfo <customer_id or customer_name> - Displays customer and child list.
Lita: alertlogic appliance agent counts <customer_id> - Displays count of agents assigned to each appliance
Lita: alertlogic policies agent counts <customer_id> - Displays count of agents assigned to each policy
Lita: alertlogic agent ip counts <customer_id> - Display count of IP's assigned to agents
Lita: alertlogic lm appliances <customer_id> - Displays customer LM appliance list.
Lita: alertlogic lm applianceinfo <customer_id> <applaince_uuid> - Displays LM appliance details.
Lita: alertlogic lm policies <customer_id> - Displays customer log assignment policies.
Lita: alertlogic lm sources <customer_id> - Displays customer log sources.
Lita: alertlogic lm hosts <customer_id> - Displays customer log hosts.
Lita: alertlogic tm appliances <customer_id> - Displays customer TM appliance list.
Lita: alertlogic tm applianceinfo <customer_id> <applaince_uuid> - Displays TM appliance details.
Lita: alertlogic tm policies <customer_id> - Displays customer threat assignment policies.
Lita: alertlogic tm hosts <customer_id> - Displays customer threat hosts hosts.
Lita: alertlogic protectedhosts status <customer_id> - Displays protected hosts summary.
Lita: alertlogic protectedhosts list <customer_id> - Displays complete protected hosts lists.
Lita: alertlogic protectedhosts search <customer_id> <protected host name or uuid>- Search protected hosts by name or uuid.
```

Example:

```
 [You] lita alertlogic customerinfo Alert
[Lita Bot]
Information for parent customer: Alert Logic Inc.
Customer ID |  Customer Name 
------------+----------------
XXXXX       | Alert Logic 
```

## Config

```
Lita.configure do |config|
  # Alert Logic API Settings
  config.handlers.alertlogic.customer_id = 'your-alertlogic-customer-id'
  config.handlers.alertlogic.api_auth = 'your-api-key-obtained-from-alert-logic:'
  config.handlers.alertlogic.lm_api_url = 'https://publicapi.alertlogic.net/api/lm/v1'
  config.handlers.alertlogic.tm_api_url = 'https://publicapi.alertlogic.net/api/tm/v1'
  config.handlers.alertlogic.customer_api_url = 'https://api.alertlogic.net/api/customer/v1'
  config.handlers.alertlogic.monitoring_api_url = 'https://api.alertlogic.net/api/monitoring/v1'
end
```

## Sample config with Hipchat plugin

```
Lita.configure do |config|
  # Logging level
  config.robot.log_level = :info
  
  # Hipchat adapter
  config.robot.adapter = :hipchat
  
  # Bot name
  config.robot.name = "Lita Bot"

  # Bot admins Type: String or Array of Jabber ID(s)
  config.robot.admins = ['some_jabber_id@chat.hipchat.com']
  config.adapters.hipchat.jid = 'bots-hipchat-jabber-id@chat.hipchat.com'
  config.adapters.hipchat.password = 'bots-password'

  # Hipchat room(s) Type: String or Array
  config.adapters.hipchat.rooms = :all
  
  # Debugging mode
  #config.adapters.hipchat.debug = false

  # Alert Logic Settings
  config.handlers.alertlogic.customer_id = 'your-alertlogic-customer-id'
  config.handlers.alertlogic.api_auth = 'your-api-key-obtained-from-alert-logic:'
  config.handlers.alertlogic.lm_api_url = 'https://publicapi.alertlogic.net/api/lm/v1'
  config.handlers.alertlogic.tm_api_url = 'https://publicapi.alertlogic.net/api/tm/v1'
  config.handlers.alertlogic.customer_api_url = 'https://api.alertlogic.net/api/customer/v1'
end
```

## License

[MIT](http://opensource.org/licenses/MIT)
