module Kubernetes
  class Status
    attr_reader :code, :message, :reason

    def initialize(data)
      @code = data.fetch("code")
      @status = data.fetch("status")
      @message = data.fetch("message")
      @reason = data.fetch("reason")
    end
  end
end
