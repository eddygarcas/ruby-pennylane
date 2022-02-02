# frozen_string_literal: true

require_relative "pennylane/version"
require "httparty"
require 'active_support/isolated_execution_state'
require "active_support/core_ext/module"
require "active_support/core_ext/object"

module Ruby
  module Pennylane

    # See https://ruby-doc.org/core-3.0.2/Kernel.html#method-i-sprintf
    mattr_reader :url, default:
      {
        v1: "https://app.pennylane.tech/api/external/v1/%<element>s/%<id>s?filter=%<filter>s&page=%<page>d&locale=%<locale>s"
      }
    class Error < StandardError; end

    class Client
      include HTTParty
      format :json
      headers 'Content-Type': "application/json"
      headers Accept: "application/json"

      attr_accessor :token

      def initialize(args)
        @token ||= args.fetch(:token, Rails.configuration.pennylane_token)
      end

      # call(method: :get, element: customers, id: 3, filter: [{"field": "customer_id", "operator": "eq", "value": "4c02116c-1793-4e3d-becf-6870ef12d441"}], body: { elem: { } })
      # method: :get by default
      def call(args)
        return {error: :missing_argument, status: :unprocessable_entity}.as_json unless args[:element]

        http_method(args)
      end

      private

      def http_method(args)
        self.class.headers(Authorization: "Bearer #{@token || args[:token]}")
        # See https://ruby-doc.org/core-3.0.2/String.html#method-i-25
        url = Pennylane.url[:v1] % {
          element: args[:element],
          id: args.fetch(:id, nil),
          filter: args.fetch(:filter, nil)&.to_json,
          locale: args.fetch(:locale, nil),
          page: args[:page] || 0
        }
        self.class.method(args.fetch(:method, :get)).call(url, body: JSON.generate(args.fetch(:body, {})))
      rescue => e
        {error: e&.message, status: :not_found}.as_json
      end
    end
  end
end
