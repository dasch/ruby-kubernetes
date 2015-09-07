require 'json'
require 'kubernetes/connection'
require 'kubernetes/pod'
require 'kubernetes/replication_controller'
require 'kubernetes/namespace'
require 'kubernetes/stream'
require 'kubernetes/watch_event'
require 'kubernetes/status'

module Kubernetes
  class Error < StandardError
    attr_reader :status

    def initialize(status:)
      super(status.message)

      @status = status
    end
  end

  class Client
    DEFAULT_NAMESPACE = "default".freeze

    def initialize(namespace: DEFAULT_NAMESPACE)
      @connection = Connection.new(namespace: namespace)
    end

    def create_pod(pod)
      data = post("pods", body: pod.to_json)
      Pod.new(data)
    end

    def get_pod(name)
      data = get("pods/#{name}")
      Pod.new(data)
    end

    def get_pods
      get("pods").
        fetch("items").
        map {|item| Pod.new(item) }
    end

    def watch_pods
      stream = Stream.new(@connection)

      stream.each("watch/pods") do |line|
        yield WatchEvent.new(JSON.parse(line))
      end
    end

    def create_replication_controller(rc)
      data = post("replicationcontrollers", body: rc.to_json)
      ReplicationController.new(data)
    end

    def get_replication_controller(name)
      data = get("replicationcontrollers/#{name}")
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

    def logs(pod_name)
      get("pods/#{pod_name}/log")
    end

    private

    def get(*args)
      request(:get, *args)
    end

    def post(*args)
      request(:post, *args)
    end

    def delete(*args)
      request(:delete, *args)
    end

    def request(*args)
      response = @connection.request(*args)

      body = response.headers["Content-Type"] =~ /json/ ?
        JSON.parse(response.body) :
        response.body

      if response.status == 200 || response.status == 201
        body
      else
        raise Error, status: Status.new(body)
      end
    end
  end
end
