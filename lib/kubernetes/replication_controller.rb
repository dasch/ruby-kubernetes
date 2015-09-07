require 'kubernetes/metadata'
require 'kubernetes/replication_controller_spec'
require 'kubernetes/replication_controller_status'

module Kubernetes
  class ReplicationController
    attr_reader :metadata, :spec, :status

    def initialize(data)
      @metadata = Metadata.new(data.fetch("metadata"))
      @spec = ReplicationControllerSpec.new(data.fetch("spec"))
      @status = ReplicationControllerStatus.new(data.fetch("status"))
    end
  end
end
