require 'time'

module Kubernetes
  class Metadata
    attr_reader :name, :link, :uid, :resource_version, :creation_timestamp

    def initialize(data)
      @name = data.fetch("name", nil)
      @namespace = data.fetch("namespace", nil)
      @link = data.fetch("selfLink", nil)
      @uid = data.fetch("uid", nil)
      @resource_version = data.fetch("resourceVersion", nil)
      @creation_timestamp = data.fetch("creationTimestamp") && Time.iso8601(data.fetch("creationTimestamp"))
      @generate_name = data.fetch("generateName", nil)
      @labels = data.fetch("labels", {})
      @annotations = data.fetch("annotations", {})
    end
  end
end
