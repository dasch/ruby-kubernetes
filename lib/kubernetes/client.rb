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

    def get_pods
      response = @connection.get(path: "/api/v1/namespaces/default/pods")
      data = JSON.parse(response.body)
      data.fetch("items").map {|item| Pod.new(item) }
    end

    class Pod
      attr_reader :metadata, :spec, :status

      def initialize(data)
        @metadata = Metadata.new(data.fetch("metadata"))
        @spec = PodSpec.new(data.fetch("spec"))
        @status = PodStatus.new(data.fetch("status"))
      end
    end

    class PodSpec
      def initialize(data)
        @containers = data.fetch("containers", []).map {|item|
          Container.new(item)
        }

        @restart_policy = data.fetch("restartPolicy")
      end
    end

    class PodStatus
      def initialize(data)
        @phase = data.fetch("phase")
        @message = data.fetch("message", nil)
        @reason = data.fetch("reason", nil)
        @host_ip = data.fetch("hostIP", nil)
        @pod_ip = data.fetch("podIP", nil)
        @start_time = Time.iso8601(data.fetch("startTime"))
      end

      def pending?
        @phase == "Pending"
      end

      def running?
        @phase == "Running"
      end

      def succeeded?
        @phase == "Succeeded"
      end

      def failed?
        @phase == "Failed"
      end
    end

    class Container
      attr_reader :name, :image, :command, :args, :working_dir
      attr_reader :image_pull_policy, :termination_message_path

      def initialize(data)
        @name = data.fetch("name")
        @image = data.fetch("image")
        @command = data.fetch("command", [])
        @args = data.fetch("args", [])
        @working_dir = data.fetch("workingDir", nil)
        @image_pull_policy = data.fetch("imagePullPolicy")
        @termination_message_path = data.fetch("terminationMessagePath")
      end
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
        @name = data.fetch("name")
        @namespace = data.fetch("namespace", nil)
        @link = data.fetch("selfLink")
        @uid = data.fetch("uid")
        @resource_version = data.fetch("resourceVersion")
        @creation_timestamp = Time.iso8601(data.fetch("creationTimestamp"))
        @generate_name = data.fetch("generateName", nil)
        @labels = data.fetch("labels", [])
        @annotations = data.fetch("annotations", [])
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
