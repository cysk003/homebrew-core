class Inshellisense < Formula
  desc "IDE style command-line auto complete"
  homepage "https://github.com/microsoft/inshellisense"
  url "https://registry.npmjs.org/@microsoft/inshellisense/-/inshellisense-0.0.4.tgz"
  sha256 "413c9a1657bb5b31353dbb372e25934a712c57857bd09199889f6cb64c441fb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ee78fc9e63d7b1ed56da5975ddb36ff0cae0212148750476c33525fe3d4fcc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ee78fc9e63d7b1ed56da5975ddb36ff0cae0212148750476c33525fe3d4fcc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ee78fc9e63d7b1ed56da5975ddb36ff0cae0212148750476c33525fe3d4fcc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8ee78fc9e63d7b1ed56da5975ddb36ff0cae0212148750476c33525fe3d4fcc1"
    sha256 cellar: :any_skip_relocation, sonoma:            "8b1528631c0b7d933313f575af46dd4149bde1c015f1b1b073c616dc027363f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ecc05a9fb139603cee01a26edea11e5e1b3a6ce0bb85b57ba852894a5e99250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5a653e428ccb4e51c11f528a98b19054f64405dfb03f89feb62148b52e92d187"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "inshellisense session", shell_output("#{bin}/is --check")
  end
end
