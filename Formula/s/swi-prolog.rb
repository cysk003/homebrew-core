class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  stable do
    url "https://www.swi-prolog.org/download/stable/src/swipl-10.0.2.tar.gz"
    sha256 "e42cc098f7b8a6051c4f79a99b55162d467098aba60f69649bdc7583f0734b57"

    # TODO: remove the resource and patch when the stable release includes the
    # prebuilt icon (devel 10.1.13+)
    on_macos do
      resource "swipl.icns" do
        url "https://raw.githubusercontent.com/SWI-Prolog/swipl-devel/05262941a70720fefdd16f649f03e50fe2b069d6/desktop/swipl.icns"
        sha256 "022530bf60d40ae425a32d7758d4bfc1896b2b99e3238a6a051d68bd49397562"
      end

      # Backport of shipping a prebuilt macOS icon instead of running `iconutil`, which the
      # build sandbox does not allow. `patch` cannot apply the binary icon in the commit
      # (GNU patch rejects git binary diffs, Apple's skips them), so it comes as a resource.
      patch do
        url "https://github.com/SWI-Prolog/swipl-devel/commit/05262941a70720fefdd16f649f03e50fe2b069d6.patch?full_index=1"
        sha256 "7d0c7ebfad36ef48c8511c3caa1a4a042d62438155e8377f70dd79288947173a"
        type :backport
      end
    end
  end

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "658967ea1fc58394cd4efeb57b8fa0a2ec5d9a359822655a8657211369d47a87"
    sha256 arm64_sequoia: "c0d227bc5e7907a1d0498d154687d45bea093b19b78f37542ba9b89f5a3a616d"
    sha256 arm64_sonoma:  "83360173120efdd80d1807dad53287db7d1ade703197a3740a6ccfa7d2fe06cd"
    sha256 sonoma:        "8d68b36e1f86eb033035c3e16dfba3956b260c726ba876771dac77657893f74e"
    sha256 arm64_linux:   "0da6dee24b78dd05455eabdb5ea6e83589a1e61c464bc9d4c4e22d3defa73abf"
    sha256 x86_64_linux:  "ba920440f195ac462e39656d8604ba83045b39bb86948cca3700527c5f9520c9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "unixodbc"

  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove bundled libraries
    rm_r("packages/libedit/libedit")
    (buildpath/"desktop").install resource("swipl.icns") if OS.mac? && build.stable?

    args = %W[
      -DSWIPL_PACKAGES_GUI=OFF
      -DSWIPL_PACKAGES_JAVA=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
      -DSWIPL_CC=#{ENV.cc}
      -DSWIPL_CXX=#{ENV.cxx}
      -DSYSTEM_LIBEDIT=ON
    ]
    # Let Homebrew's build environment handle dependencies
    args << "-DMACOSX_DEPENDENCIES_FROM=None" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.pl").write <<~PROLOG
      test :-
          write('Homebrew').
    PROLOG
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
