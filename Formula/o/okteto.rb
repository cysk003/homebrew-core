class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.30.1.tar.gz"
  sha256 "eeb7fc3159feb3c970a2d716d6c54eb1fca2600222e057586ee36b0835913ad9"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2b9dadb88e1991835bcf21f80160b04e9fbe24e84feba5dc3480179719c0c50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5fd38e174a31ac484225e4622702dec18c43a6244677c4b585386f9de6c6b6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72327e84778b557dd283d404ec2d1243c14839d0e2691ef86c27212853c97016"
    sha256 cellar: :any_skip_relocation, sonoma:         "0776062f0c217e9aac42d3c21a63aa1dcb323c1a39d01bc1895bc533b127ef8a"
    sha256 cellar: :any_skip_relocation, ventura:        "16e767ad0c0b547d3ee1a57b31a90e71720c7402db260d29acd88ccabf2c7665"
    sha256 cellar: :any_skip_relocation, monterey:       "5583edba5f312ed321676fbd7818dff2a64a18958b5f072d820096212c3429f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "957c7eca6d9121afe9bda420aef594cab875709db5fea1e41d5002d8ccc8fa2c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
