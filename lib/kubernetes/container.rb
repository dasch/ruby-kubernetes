module Kubernetes
  class Container
    attr_reader :name, :image, :command, :args, :working_dir
    attr_reader :image_pull_policy, :termination_message_path

    def initialize(data)
      @name = data.fetch("name")
      @image = data.fetch("image")
      @command = data.fetch("command", [])
      @args = data.fetch("args", [])
      @working_dir = data.fetch("workingDir", nil)
      @image_pull_policy = data.fetch("imagePullPolicy")
      @termination_message_path = data.fetch("terminationMessagePath")
    end
  end
end
