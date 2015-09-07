module Kubernetes
  class ReplicationControllerStatus
    def initialize(data)
      @replicas = data.fetch("replicas")
      @observed_generation = data.fetch("observedGeneration", nil)
    end
  end
end
