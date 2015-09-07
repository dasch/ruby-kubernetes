require 'kubernetes/metadata'
require 'kubernetes/namespace_spec'
require 'kubernetes/namespace_status'

module Kubernetes
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
end
