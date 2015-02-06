module FaradayMiddleware
  # Request middleware that encodes the body as JSON.
  #
  # Processes only requests with matching Content-type or those without a type.
  # If a request doesn't have a type but has a body, it sets the Content-type
  # to JSON MIME-type.
  #
  # Doesn't try to encode bodies that already are in string form.
  class Auth < Faraday::Middleware

    AUTH_HEADER = 'Authorization'.freeze
    def initialize(app, token = nil, options = {})
      super(app)
      options, token = token, nil if token.is_a? Hash
      @token = token && token.to_s
      @auth_header = options.fetch(:auth_header, AUTH_HEADER).to_s
      raise ArgumentError, ":auth_header can't be blank" if @auth_header.empty?
    end

    def call(env)
      env[:request_headers][@auth_header] ||= @token
      @app.call env
    end
  end

end

if Faraday::Middleware.respond_to? :register_middleware
  Faraday::Request.register_middleware \
    :api_header_auth    => lambda { FaradayMiddleware::Auth }
end
