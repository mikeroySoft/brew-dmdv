class DockerMachineDriverVmware < Formula
  desc "Docker machine driver for VMware Fusion and Workstation."
  homepage "https://www.vmware.com/products/personal-desktop-virtualization.html"
  url "https://github.com/machine-drivers/docker-machine-driver-vmware.git",
    :tag      => "v0.1.1",
    :revision => "cd992887ede19ae63e030c63dda5593f19ed569c"

  bottle do
    cellar  :any_skip_relocation
    sha256 "afe8e5f6dfd7c79fb5ed8216118521d2652a610a41e5f50c8066cbd7bd637a88" => :darwin_amd64
    sha256 "8c12888cca194c1a5f269e80139d273bf5fe26e75062ca640cf4daea267ed458" => :windows_amd64
    sha256 "978bb72086a9905faa38d5104c7f66be86ac46f8f3f12daae5e3e4579fdbf802" => :linux_amd64
  end    

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/machine-drivers/docker-machine-driver-vmware"
    dir.install buildpath.children

    cd dir do
       system "go", "build", "-o", "#{bin}/docker-machine-driver-vmware",
            "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end


  test do
    docker_machine = Formula["docker-machine"].opt_bin/"docker-machine"
    output = shell_output("#{docker_machine} create --driver vmware -h")
    assert_match "engine-env", output
  end
end
