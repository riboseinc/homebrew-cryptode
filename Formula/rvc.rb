class Rvc < Formula
  desc "RVC: Relaxed VPN Client"
  homepage "https://github.com/riboseinc/rvc"
  url "https://github.com/riboseinc/rvc/archive/v1.0.3.tar.gz"
  sha256 "cb89f3ddf9e81a069876cb157d122be338ee12b00f09a89061cd9f17813891f9"
  head "https://github.com/riboseinc/rvc.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl"
  depends_on "openvpn"

  devel do
    version '1.0.3'
  end

  def install
    system './autogen.sh'
    system "./configure", "--prefix=#{prefix}",
            "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  plist_options startup: false

  def caveats; <<-EOS.undent
    rvd and rvc requires to be installed in `/opt`
    run:
      sudo /usr/local/bin/rvc_install.sh

    Ensure that `/opt/rvc/bin` is in your PATH and is set before `/usr/local/bin`. E.g.:
      PATH=/opt/rvc/bin:/usr/local/bin

    If this is an upgrade and you already have the plist loaded:
      sudo /usr/local/bin/rvc_uninstall.sh
      sudo /usr/local/bin/rvc_install.sh
    EOS
  end

  test do
    system "rvc", "--version"
  end
end
