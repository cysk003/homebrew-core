class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.7.0.tar.gz"
  sha256 "2ffabc4853bb1c70e29e6585ea15dfef8b2bdb86b6ccaad0a3b8c92b5d526d1b"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]
  head "https://www.chiark.greenend.org.uk/ucgi/~ianmdlvl/githttp/adns.git", branch: "master"

  livecheck do
    url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/"
    regex(/href=.*?adns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43a664803bb1f241373c496746f8af1c8cffe9830e6e6fadde7f0941510f4fca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "476b8d52436281919b2d7c58842d10639c2b7b1b36040d9e92880c779efafcb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce908b2bbf29716b8cbf5b720f60bcc9cc4fc9ec8a211fe7883c042529538785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "40b39178f471c2ff5a3f42832d0333841fbc36eb1effc0325686a5089903fb0e"
    sha256 cellar: :any_skip_relocation, sonoma:            "f98a269f36fb69622b6a8739766ff6c8ac5c2baec826203a93a4d58ce1ff2788"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d983ba100a6cb146c0aa23ecc55c80d8b06aa5876979f40961faaae4662d83c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "41d5aeafb129564e9f91c794235a9d256abb0b8b4dc8ee52d55f7241700e2a03"
  end

  uses_from_macos "m4" => :build

  # Add missing `<sys/random.h>` header
  patch :DATA

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"adnsheloex", "--version"
  end
end

__END__
diff --git a/src/nextid.c b/src/nextid.c
index c33e175..02508ea 100644
--- a/src/nextid.c
+++ b/src/nextid.c
@@ -21,6 +21,7 @@
  */
 
 #include "internal.h"
+#include <sys/random.h>
 
 /* common, error handling */
