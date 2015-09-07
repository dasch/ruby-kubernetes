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

    def initialize
      @connection = Excon.new(KUBERNETES_HOST)
      @namespace = DEFAULT_NAMESPACE
    end

    def get_pods
      get("pods").
        fetch("items").
        map {|item| Pod.new(item) }
    end

    def get_replication_controllers
      get("replicationcontrollers").
        fetch("items").
        map {|item| ReplicationController.new(item) }
    end

    private

    def get(path)
      qualified_path = File.join("/api/v1/namespaces/#{namespace}", path)
      response = @connection.get(path: qualified_path)
      JSON.parse(response.body)
    end
  end
end
