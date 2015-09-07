require 'spec_helper'

describe Kubernetes::Client do
  describe "#get_namespaces" do
    it "lists the available namespaces" do
      client = Kubernetes::Client.new
      namespaces = client.get_namespaces

      expect(namespaces.map(&:name)).to include "default"
    end
  end
end
