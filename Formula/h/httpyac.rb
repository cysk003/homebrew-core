require "language/node"

class Httpyac < Formula
  desc "Quickly and easily send REST, SOAP, GraphQL and gRPC requests"
  homepage "https://httpyac.github.io/"
  url "https://registry.npmjs.org/httpyac/-/httpyac-6.13.0.tgz"
  sha256 "7b427bd6b357581eed1bf0c2f91472953f35ca16fc0c7c12a3845d24ae57234a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e7f15d98872ac4093b9806005181abea421246810a04becbe4da14314f9dac1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e7f15d98872ac4093b9806005181abea421246810a04becbe4da14314f9dac1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e7f15d98872ac4093b9806005181abea421246810a04becbe4da14314f9dac1"
    sha256 cellar: :any_skip_relocation, sonoma:         "235d244b5dbb59535a181a436547ff1f7a68c211ae3787eb71e8716e8b2e5e01"
    sha256 cellar: :any_skip_relocation, ventura:        "235d244b5dbb59535a181a436547ff1f7a68c211ae3787eb71e8716e8b2e5e01"
    sha256 cellar: :any_skip_relocation, monterey:       "235d244b5dbb59535a181a436547ff1f7a68c211ae3787eb71e8716e8b2e5e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df290309af3989382caf02dcafedee8c9b9c90e5edad2acbf294e4f8445b871"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"test_cases").write <<~EOS
      GET https://httpbin.org/anything HTTP/1.1
      Content-Type: text/html
      Authorization: Bearer token

      POST https://countries.trevorblades.com/graphql
      Content-Type: application/json

      query Continents($code: String!) {
          continents(filter: {code: {eq: $code}}) {
            code
            name
          }
      }

      {
          "code": "EU"
      }
    EOS

    output = shell_output("#{bin}/httpyac send test_cases --all")
    # for httpbin call
    assert_match "HTTP/1.1 200  - OK", output
    # for graphql call
    assert_match "\"name\": \"Europe\"", output
    assert_match "2 requests processed (2 succeeded, 0 failed)", output

    assert_match version.to_s, shell_output("#{bin}/httpyac --version")
  end
end
