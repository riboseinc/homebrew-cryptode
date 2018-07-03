class Rvc < Formula
  desc "RVC: Relaxed VPN Client"
  homepage "https://github.com/riboseinc/rvc"
  url "https://github.com/riboseinc/rvc/archive/v1.2.0.tar.gz"
  sha256 "d323eb74b0772e267e8b0e34e08ad536773e76e508dcbf56fc386038ff5e7045"
  head "https://github.com/riboseinc/rvc.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "https://raw.githubusercontent.com/riboseinc/homebrew-libnereon/master/Formula/libnereon.rb"
  depends_on "json-c"
  depends_on "openssl"
  depends_on "openvpn"

  devel do
    version '1.2.0'
  end

  def install
    system './autogen.sh'
    system "./configure", "--prefix=#{prefix}",
            "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  plist_options startup: false

  def caveats; <<-EOS
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
