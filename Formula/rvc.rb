class Rvc < Formula
  desc "RVC: Relaxed VPN Client"
  homepage "https://github.com/riboseinc/rvc"
  url "https://github.com/riboseinc/rvc/archive/v1.1.0.tar.gz"
  sha256 "3e7b73e8973f934d7353800d1d035c0feee1cc1a77b26d4c4d7575c5e3bbeae0"
  head "https://github.com/riboseinc/rvc.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl"
  depends_on "openvpn"

  devel do
    version '1.1.0'
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
