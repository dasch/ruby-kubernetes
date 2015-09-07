require 'kubernetes/container'

module Kubernetes
  class PodSpec
    def initialize(data)
      @containers = data.fetch("containers", []).map {|item|
        Container.new(item)
      }

      @restart_policy = data.fetch("restartPolicy")
    end
  end
end
