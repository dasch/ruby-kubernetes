require 'time'

module Kubernetes
  class Metadata
    attr_reader :name, :link, :uid, :resource_version, :creation_timestamp

    def initialize(data)
      @name = data.fetch("name")
      @namespace = data.fetch("namespace", nil)
      @link = data.fetch("selfLink")
      @uid = data.fetch("uid")
      @resource_version = data.fetch("resourceVersion")
      @creation_timestamp = Time.iso8601(data.fetch("creationTimestamp"))
      @generate_name = data.fetch("generateName", nil)
      @labels = data.fetch("labels", {})
      @annotations = data.fetch("annotations", {})
    end
  end
end
