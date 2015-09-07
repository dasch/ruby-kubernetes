module Kubernetes
  class NamespaceSpec
    attr_reader :finalizers

    def initialize(data)
      @finalizers = data.fetch("finalizers")
    end
  end
end
