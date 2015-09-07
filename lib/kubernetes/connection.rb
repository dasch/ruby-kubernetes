require 'excon'

module Kubernetes
  class Connection
    KUBERNETES_HOST = ENV.fetch("KUBERNETES_HOST", "http://localhost:8080").freeze

    attr_reader :namespace

    def initialize(host: KUBERNETES_HOST, namespace:)
      @connection = Excon.new(host)
      @namespace = namespace
    end

    def request(method, path, prefix: "/namespaces/#{namespace}", **options)
      qualified_path = File.join("/api/v1", prefix || "", path)

      @connection.request(method: method, path: qualified_path, **options)
    end

    def stream(path, &block)
      handler = lambda {|chunk, remaining_bytes, total_bytes|
        block.call(chunk)
      }

      request(:get, path, prefix: nil, response_block: handler)
    ensure
      # If the stream is stopped by the client there may be stuff still lingering
      # in the socket.
      @connection.reset
    end
  end
end
