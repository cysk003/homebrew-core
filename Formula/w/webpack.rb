require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.100.1.tgz"
  sha256 "cf46a6482ff67e3d6173231e4c0e83fbbeaf9bf54fed5ad6fb8cc50a33a2f9dc"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eeb826b7168a00b597a4945176e81bcf8d450973573fdeb9bba3c04390d4459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eeb826b7168a00b597a4945176e81bcf8d450973573fdeb9bba3c04390d4459"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eeb826b7168a00b597a4945176e81bcf8d450973573fdeb9bba3c04390d4459"
    sha256 cellar: :any_skip_relocation, sonoma:        "1826ebb7118e17b564b024374ec155fbbe07f3b012337edf5f9da69631157216"
    sha256 cellar: :any_skip_relocation, ventura:       "1826ebb7118e17b564b024374ec155fbbe07f3b012337edf5f9da69631157216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eeb826b7168a00b597a4945176e81bcf8d450973573fdeb9bba3c04390d4459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eeb826b7168a00b597a4945176e81bcf8d450973573fdeb9bba3c04390d4459"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-6.0.1.tgz"
    sha256 "f407788079854b0d48fb750da496c59cf00762dce3731520a4b375a377dec183"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *std_npm_args(prefix: false), "--force"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin/"webpack", "bundle", "--mode=production", testpath/"index.js"
    assert_match 'const e=document.createElement("div");', (testpath/"dist/main.js").read
  end
end
