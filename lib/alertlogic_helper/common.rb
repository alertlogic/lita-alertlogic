require 'json'
require 'pretty_table'
# Alertlogic Helper
module AlertlogicHelper
  # Common Helper
  module Common
    def parse_json(json)
      return JSON.parse(json)
    rescue TypeError, JSON::ParserError
      return t('error.json_parse')
    end

    def pretty_json(json)
      JSON.pretty_generate(json)
    end

    def build_table(data, headers)
      PrettyTable.new(data, headers).to_s
    end

    def check_msg_size?(string)
      string.length >= 9_500 && string.length <= 10_000
    end

    def search?(key, name, hash)
      hash[key].downcase.include? name.downcase
    end

    def valid_uuid?(string)
      UUID.validate(string)
    end
  end
end
