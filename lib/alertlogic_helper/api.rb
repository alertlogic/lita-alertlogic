# Alertlogic Helper
module AlertlogicHelper
  # Api Helper
  module Api
    def api_call(options = {})
      customer_id = options[:customer_id]
      type        = options[:type] || nil
      source      = options[:source] || nil
      url         = options[:url] || nil

      url_options = {
        customer_id: customer_id,
        api_type: type,
        source_type: source
      }

      # Construct URL if url not provided
      url = construct_api_url(url_options) if url.nil?
      http_resp = http(config.http_options).get(url) do |req|
        req.headers  = headers
        req.options.timeout = 90
      end
      http_resp.body.to_s
    end

    def construct_api_url(options = {})
      customer_id = options[:customer_id]
      api_type = options[:api_type]
      source_type = options[:source_type] || nil

      case api_type
      when 'customer'
        return "#{config.customer_api_url}/#{customer_id}"
      when 'monitoring'
        return "#{config.monitoring_api_url}/#{source_type}/#{customer_id}"
      when 'lm'
        return "#{config.lm_api_url}/#{customer_id}/#{source_type}"
      when 'tm'
        return "#{config.tm_api_url}/#{customer_id}//#{source_type}"
      else
        return t('error.generic')
      end
    end

    def headers
      {}.tap do |headers|
        headers['Authorization'] = "Basic #{Base64.encode64(config.api_auth).chomp.gsub(/\n/, '')}" if config.api_auth
        headers['Content-Type']  = 'application/json'
        headers['Accept']        = 'application/json'
      end
    end
  end
end
