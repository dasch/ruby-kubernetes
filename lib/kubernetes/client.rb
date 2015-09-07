require 'excon'
require 'json'
require 'time'

module Kubernetes
  class Client
    KUBERNETES_HOST = "http://localhost:8080"

    def initialize
      @connection = Excon.new(KUBERNETES_HOST)
    end

    def get_namespaces
      response = @connection.get(path: "/api/v1/namespaces")
      data = JSON.parse(response.body)
      data.fetch("items").map {|item| Namespace.new(item) }
    end

    class Namespace
      attr_reader :metadata, :spec, :status

      def initialize(data)
        @metadata = Metadata.new(data.fetch("metadata"))
        @spec = NamespaceSpec.new(data.fetch("spec"))
        @status = NamespaceStatus.new(data.fetch("status"))
      end

      def name
        metadata.name
      end
    end

    class Metadata
      attr_reader :name, :link, :uid, :resource_version, :creation_timestamp

      def initialize(data)
        @name, @link, @uid = data.values_at("name", "selfLink", "uid")
        @resource_version = data.fetch("resourceVersion")
        @creation_timestamp = Time.iso8601(data.fetch("creationTimestamp"))
      end
    end

    class NamespaceSpec
      attr_reader :finalizers

      def initialize(data)
        @finalizers = data.fetch("finalizers")
      end
    end

    class NamespaceStatus
      attr_reader :phase

      def initialize(data)
        @phase = data.fetch("phase")
      end
    end
  end
end
