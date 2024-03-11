# frozen_string_literal: true

module Weather
  class Live
    class Base
      attr_reader   :api_obj, :response_content_type, :status
      attr_accessor :http_client, :hash_key

      EXACT_ERROR_RAISER = {
        429 => ->(status, msg) { raise Weather::Exceptions::ApiLimitError.new(status, msg) },
        404 => ->(status, msg) { raise Weather::Exceptions::UnknownLocation.new(status, msg) },
        401 => ->(status, msg) { raise Weather::Exceptions::Unauthorized.new(status, msg) }
      }.freeze

      RANGE_ERROR_RAISER = {
        (500..) => ->(status, msg) { raise Weather::Exception.new(status, msg) }
      }.freeze

      def initialize(api_obj)
        @api_obj = api_obj
        @http_client = Weather::Connection.start
      end

      def execute(**args)
        # verify parameters
        @parameters = build_params(args)
        # Redis request
        responce = Weather::Live::Cache.fetch_cache(extract_hash_key(@parameters))
        # API request
        responce || get(url, @parameters)
      end

      private

      def extract_hash_key(data)
        raise NotImplementedError, "#{self.class}.#{__method__}"
      end

      def get(path, params)
        api_call do
          @http_client.get do |req|
            req.url = path
            req.params = params
          end
        end
      end

      def api_call
        response = yield
        @status = response.status
        @response_content_type = content_type(response.headers)
        body = response_parse(response.body)
        raise_error(
          error_message(body)
        )

        [@status, response.headers, body]
      end

      def error_message(body)
        raise NotImplementedError, "#{self.class}.#{__method__}"
      end

      def raise_error(message)
        EXACT_ERROR_RAISER[status]&.call(status, message)

        RANGE_ERROR_RAISER.each do |k, v|
          v.call(status, message) if k.include?(status)
        end
      end

      def content_type(headers)
        case headers.[]('content-type')
        when %r{application/json}
          :json
        when %r{text/html}
          :html
        else
          :any
        end
      end

      def response_parse(body)
        if response_content_type == :json
          begin
            JSON.parse body, symbolize_names: true
          rescue JSON::ParserError
            # Logger.push e
            {}
          end
        else
          body
        end
      end

      def url
        'http://api.openweathermap.org/'
      end

      def build_params(_parameters = {})
        { appid: @api_obj.api_key }
      end
    end
  end
end
