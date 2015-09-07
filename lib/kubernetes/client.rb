require 'excon'
require 'json'

require 'kubernetes/pod'
require 'kubernetes/replication_controller'
require 'kubernetes/namespace'

module Kubernetes
  class Client
    KUBERNETES_HOST = "http://localhost:8080".freeze
    DEFAULT_NAMESPACE = "default".freeze

    attr_reader :namespace

    def initialize(namespace: DEFAULT_NAMESPACE)
      @connection = Excon.new(KUBERNETES_HOST)
      @namespace = namespace
    end

    def create_pod(pod)
      data = post("pods", body: pod.to_json)
      Pod.new(data)
    end

    def get_pods
      get("pods").
        fetch("items").
        map {|item| Pod.new(item) }
    end

    def create_replication_controller(rc)
      data = post("replicationcontrollers", body: rc.to_json)
      ReplicationController.new(data)
    end

    def get_replication_controllers
      get("replicationcontrollers").
        fetch("items").
        map {|item| ReplicationController.new(item) }
    end

    def create_namespace(namespace)
      post("namespaces", prefix: nil, body: namespace.to_json)
    end

    def delete_namespace(name)
      delete("namespaces/#{name}", prefix: nil)
    end

    private

    def http(method, path, prefix: "/namespaces/#{namespace}", **options)
      qualified_path = File.join("/api/v1", prefix || "", path)
      response = @connection.request(method: method, path: qualified_path, **options)

      if response.status / 100 == 2
        JSON.parse(response.body)
      else
        raise "Failed with status #{response.status}: #{response.body}"
      end
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
  end
end
