require 'kubernetes/metadata'
require 'kubernetes/pod_spec'
require 'kubernetes/pod_status'

module Kubernetes
  class Pod
    attr_reader :metadata, :spec, :status

    def initialize(data)
      @metadata = Metadata.new(data.fetch("metadata"))
      @spec = PodSpec.new(data.fetch("spec"))
      @status = PodStatus.new(data.fetch("status"))
    end
  end
end
