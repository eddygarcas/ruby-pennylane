# frozen_string_literal: true

require_relative "pennylane/version"
require "httparty"
require "active_support/isolated_execution_state"
require "active_support/core_ext/module"
require "active_support/core_ext/object"

module Rz
  module Pennylane

    # See https://ruby-doc.org/core-3.0.2/Kernel.html#method-i-sprintf
    mattr_reader :url, default:
      {
        v2: "https://app.pennylane.com/api/external/v2/%<element>s/%<id>s?filter=%<filter>s&limit=%<limit>d&cursor=%<cursor>s"
      }

    # Setup data from initializer
    def self.setup
      yield(self)
    end

    class Error < StandardError; end

    class Client
      include HTTParty
      format :json
      headers 'Content-Type': "application/json"
      headers Accept: "application/json"

      attr_accessor :token

      def initialize(args = {})
        @token ||= args.fetch(:token, defined?(Rails) && Rails.configuration.pennylane_token || ENV["PENNYLANE_TOKEN"])
      end

      # call(method: :get, element: customers, id: 3, filter: [{"field": "customer_id", "operator": "eq", "value": "4c02116c-1793-4e3d-becf-6870ef12d441"}], body: { elem: { } })
      # method: :get by default
      def call(args)
        return { error: :missing_argument, status: :unprocessable_entity }.as_json unless args[:element]

        http_method(args)
      end

      private

      def http_method(args = {})
        self.class.headers(Authorization: "Bearer #{@token || args[:token]}")
        # See https://ruby-doc.org/core-3.0.2/String.html#method-i-25
        url = Pennylane.url[:v2] % {
          element: args[:element],
          id: args.fetch(:id, nil),
          filter: args.fetch(:filter, nil)&.to_json,
          cursor: args.fetch(:cursor, nil),
          limit: args[:limit] || 20
        }
        self.class.method(args.fetch(:method, :get)).call(url, body: JSON.generate(args.fetch(:body, {})))
      rescue StandardError => e
        { error: e&.message, status: :not_found }.as_json
      end
    end
  end
end
