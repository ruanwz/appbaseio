require 'virtus'
require 'faraday'
require 'faraday_middleware'
require 'json'
require 'pry'
require 'appbaseio/auth_middleware'

module Appbaseio

  HTTP_METHOD_MAP = {
      'list' => :post,
      'create' => :patch,
      'read' => :post,
      'update' => :patch,
      'delete' => :delete,
      'properties' => :patch
  }
  TARGETS = %w{list properties edges}
  class Client
    include Virtus.model
    attribute :server_host, String, default: 'api.appbase.io'
    attribute :app_name, String
    attribute :api_version, String, default: 'v2'
    attribute :namespace, String
    attribute :app_secret, String
    def initialize(options)
      super
    end

    def common_path
      "/#{app_name}/#{api_version}/#{namespace}"
    end

    def rest_client
      Faraday.new(url: "https://"+server_host) do |faraday|
        #faraday.request :url_encoded
        faraday.response :logger
        faraday.request :json
        faraday.response :json
        faraday.response :mashify
        faraday.request :api_header_auth, app_secret, auth_header: 'Appbase-Secret'
        faraday.adapter Faraday.default_adapter
      end
    end

    def path(target, operation, vertex)
      [common_path, vertex, "~#{target}"].compact.join '/'
    end

    def method_missing(m, *args, &block)
      operation, target = m.to_s.split('_')
      return super unless HTTP_METHOD_MAP.keys.include? operation
      return super unless TARGETS.include? target
      options = args[0] || {}
      vertex = options[:vertex] || nil
      data = {data: options[:data]}
      data = {all: true} if operation == 'read' and target == 'properties'
      data = {filters: {}} if operation == 'read' and target == 'edges'

      method = HTTP_METHOD_MAP[operation]
      if data
        resp = rest_client.send method, path(target, operation, vertex), data do |req|
          req.body = data.to_json if operation == 'delete'
        end
      else
        resp = rest_client.send method, path(target, operation, vertex) do |req|
        end
      end
      resp
    end
  end
end
