class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.1.2/squiid-1.1.2.tar.bz2"
  sha256 "f5d3564325aebf857647ff3dcb71ca4762cdedb83708001834f1afcbfacc5bbf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a443b05fa1907a2fcb23ec18d1aed61fd859b1bde705041a1007ec8130d2f859"
    sha256 cellar: :any,                 arm64_ventura:  "ca132ff60afa5d3a66c21c562c7fe919dbdef8b029d19e44a170d149b03b07df"
    sha256 cellar: :any,                 arm64_monterey: "0e1c890d209bdc4820024458acc920e06fcf774ac15581da13d872b78bb37cda"
    sha256 cellar: :any,                 sonoma:         "a9f4a0604aa3a7fc6d8c2c43c11dede38493b08f338f6e87a9da9e25f0da4ccb"
    sha256 cellar: :any,                 ventura:        "b05ad841186178cab1c3389495dfe7178830cb45a2c9a1b7a6a5eb09b69bb5a2"
    sha256 cellar: :any,                 monterey:       "7c7685b1e78fa9f9b5539dbc0d875d89b82f3339e2ffb9decacd8f534d28446e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f12ed29e01e471cb09f66eb454b02ed1d482789558addcb4aa18f43cdb9f5ea3"
  end

  depends_on "rust" => :build
  depends_on "nng"

  def install
    # Avoid vendoring `nng`.
    # "build-nng" is the `nng` crate's only default feature. To check:
    # https://gitlab.com/neachdainn/nng-rs/-/blob/v#{nng_crate_version}/Cargo.toml
    inreplace "Cargo.toml",
              /^nng = "(.+)"$/,
              'nng = { version = "\\1", default-features = false }'
    inreplace "squiid-engine/Cargo.toml",
              /^nng = { version = "(.+)", optional = true }$/,
              'nng = { version = "\\1", optional = true, default-features = false }'

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # squiid is a TUI app
    assert_match version.to_s, shell_output("#{bin}/squiid --version")

    assert check_binary_linkage(bin/"squiid", Formula["nng"].opt_lib/shared_library("libnng")),
      "No linkage with libnng! Cargo is likely using a vendored version."
  end
end
