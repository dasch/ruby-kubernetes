module Kubernetes
  class NamespaceStatus
    attr_reader :phase

    def initialize(data)
      @phase = data.fetch("phase")
    end
  end
end
