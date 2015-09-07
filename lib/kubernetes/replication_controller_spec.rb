require 'kubernetes/pod_template_spec'

module Kubernetes
  class ReplicationControllerSpec
    def initialize(data)
      @replicas = data.fetch("replicas")
      @selector = data.fetch("selector")
      @template = PodTemplateSpec.new(data.fetch("template"))
    end
  end
end
