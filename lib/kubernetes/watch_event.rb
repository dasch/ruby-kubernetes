module Kubernetes
  class WatchEvent
    attr_reader :type, :object

    def initialize(data)
      @type = data.fetch("type")
      @object = map_object(data.fetch("object"))
    end

    private

    def map_object(data)
      case data.fetch("kind")
      when "Pod" then Pod.new(data)
      else raise "unknown kind `#{data.fetch('kind')}`"
      end
    end
  end
end
