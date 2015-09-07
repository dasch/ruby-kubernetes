require 'kubernetes/metadata'
require 'kubernetes/pod_spec'

module Kubernetes
  class PodTemplateSpec
    def initialize(data)
      @metadata = Metadata.new(data.fetch("metadata"))
      @spec = PodSpec.new(data.fetch("spec"))
    end
  end
end
