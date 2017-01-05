require 'time'

module Kubernetes
  class PodStatus
    attr_reader :phase, :reason, :message

    def initialize(data)
      @phase = data.fetch("phase")
      @message = data.fetch("message", nil)
      @reason = data.fetch("reason", nil)
      @host_ip = data.fetch("hostIP", nil)
      @pod_ip = data.fetch("podIP", nil)
      @start_time = data.key?("startTime") && Time.iso8601(data.fetch("startTime"))
    end

    def pending?
      @phase == "Pending"
    end

    def running?
      @phase == "Running"
    end

    def succeeded?
      @phase == "Succeeded"
    end

    def failed?
      @phase == "Failed"
    end
  end
end
