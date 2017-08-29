class Rvc < Formula
  desc "Ribose VPN Client"
  homepage "https://github.com/riboseinc/rvc"
  # url "https://github.com/riboseinc/rnp/archive/3.99.18.tar.gz"
  # sha256 "b61ae76934d4d125660530bf700478b8e4b1bb40e75a4d60efdb549ec864c506"
  head "https://github.com/riboseinc/rvc.git"
  
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openvpn"
  depends_on "botan"

  devel do
    version '0.9.0'
  end

  def install
    jsonc = Formula["json-c"]

    ENV.append "CFLAGS", "-I#{jsonc.opt_include}/json-c"
    ENV.append "LDFLAGS", "-L#{jsonc.opt_lib}"

    (buildpath/"m4").mkpath

    system "autoreconf", "-ivf"
    system "./configure", "--prefix=/opt/local"
    system "sudo", "make", "install"
  end

  test do
    system "rvc", "--version"
  end
end
