require 'kubernetes/version'

module Kubernetes
  def self.new(*args)
    Client.new(*args)
  end
end

require 'kubernetes/client'
