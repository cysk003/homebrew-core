class Opencrabs < Formula
  desc "Autonomous, self-improving AI agent in a single Rust binary"
  homepage "https://opencrabs.com"
  url "https://github.com/adolfousier/opencrabs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "90de8e6eb09933296f42af44a0779233e86668391aaba92adcc984777008574b"
  license "MIT"
  head "https://github.com/adolfousier/opencrabs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddfb5beab43de5450f24ca7b2cf7f0f82b13b105d302979f42811f9df9685c58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0fd6d981e44302e6430e12f2ef8a1d7c914dff5761e20fef316b9c6f0127f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905ced314307c22695d1ab43134cbd71f440f6d4137261a581a1d9bcf0c21a4f"
    sha256 cellar: :any,                 arm64_linux:   "6b0c7b143b959defcf4c9b0ee9be5bf6d63f29d72e4e140e7265401e8be82e33"
    sha256 cellar: :any,                 x86_64_linux:  "612413c5a24e270561d3641d2566e37da35d3372b55e98401773f23db57549ad"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@3"
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"opencrabs", "init"

    config = testpath/".opencrabs/config.toml"
    assert_path_exists config
    assert_match "[provider_registry]", config.read

    assert_match "Database:", shell_output("#{bin}/opencrabs config")
  end
end
