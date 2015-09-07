require 'excon'
require 'json'

require 'kubernetes/pod'
require 'kubernetes/replication_controller'
require 'kubernetes/namespace'

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

    def get_pods
      response = @connection.get(path: "/api/v1/namespaces/default/pods")
      data = JSON.parse(response.body)
      data.fetch("items").map {|item| Pod.new(item) }
    end

    def get_replication_controllers
      response = @connection.get(path: "/api/v1/namespaces/default/replicationcontrollers")
      data = JSON.parse(response.body)
      data.fetch("items").map {|item| ReplicationController.new(item) }
    end
  end
end
