module Kubernetes
  class Stream
    def initialize(connection)
      @connection = connection
    end

    def each(*args)
      buffer = ""

      @connection.stream(*args) do |chunk|
        buffer << chunk

        while line = buffer.slice!(/\A.+\n/)
          yield line
        end
      end
    end
  end
end
