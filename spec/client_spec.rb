require 'spec_helper'

describe Kubernetes::Client do
  let(:client) { Kubernetes::Client.new }

  describe "#get_namespaces" do
    it "lists the available namespaces" do
      namespaces = client.get_namespaces

      expect(namespaces.map(&:name)).to include "default"
    end
  end

  describe "#get_pods" do
    it "lists all pods in the namespace" do
      pods = client.get_pods

      expect(pods.count).to be > 0
    end
  end
end
