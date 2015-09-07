require 'spec_helper'

describe Kubernetes::Client do
  let(:client) { Kubernetes::Client.new(namespace: namespace) }
  let(:namespace) { "ruby-k8s-#{rand(10000)}" }

  before do
    client.create_namespace(metadata: { name: namespace })
  end

  after do
    client.delete_namespace(namespace)
  end

  it "creates and lists pods" do
    pod = client.create_pod({
      metadata: {
        name: "testing",
      },
      spec: {
        containers: [
          {
            name: "testing-1",
            image: "nginx",
            imagePullPolicy: "IfNotPresent",
          }
        ],
        restartPolicy: "Always",
        dnsPolicy: "Default",
      }
    })

    expect(client.get_pods).to eq [pod]
    expect(client.get_pod("testing")).to eq pod
  end

  it "lists all replication controllers in the namespace" do
    rc = client.create_replication_controller({
      metadata: {
        name: "testing",
      },
      spec: {
        selector: {
          app: "circus"
        },
        template: {
          metadata: {
            labels: {
              app: "circus"
            },
          },
          spec: {
            containers: [
              {
                name: "testing-1",
                image: "nginx",
                imagePullPolicy: "IfNotPresent",
              }
            ],
            restartPolicy: "Always",
            dnsPolicy: "Default",
          }
        },
      }
    })

    expect(client.get_replication_controllers).to eq [rc]
    expect(client.get_replication_controller("testing")).to eq rc
  end
end
