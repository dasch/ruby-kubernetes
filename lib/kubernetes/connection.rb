require 'excon'
require 'json'
require 'kubernetes/status'

module Kubernetes
  class Error < StandardError
    attr_reader :status

    def initialize(status:)
      super(status.message)

      @status = status
    end
  end

  class Connection
    KUBERNETES_HOST = "http://localhost:8080".freeze

    def initialize(namespace:)
      @connection = Excon.new(KUBERNETES_HOST)
      @namespace = namespace
    end

    def get(*args)
      http(:get, *args)
    end

    def post(*args)
      http(:post, *args)
    end

    def delete(*args)
      http(:delete, *args)
    end

    private

    attr_reader :namespace

    def http(method, path, prefix: "/namespaces/#{namespace}", **options)
      qualified_path = File.join("/api/v1", prefix || "", path)
      response = @connection.request(method: method, path: qualified_path, **options)

      if response.status / 100 == 2
        if response.headers["Content-Type"] =~ /json/
          JSON.parse(response.body)
        else
          response.body
        end
      else
        raise Error, status: Status.new(JSON.parse(response.body))
      end
    end
  end
end
