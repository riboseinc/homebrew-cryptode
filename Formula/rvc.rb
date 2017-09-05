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

  devel do
    version '0.9.0'
  end

  def install
    jsonc = Formula["json-c"]

    ENV.append "CFLAGS", "-I#{jsonc.opt_include}/json-c"
    ENV.append "LDFLAGS", "-L#{jsonc.opt_lib}"

    (buildpath/"m4").mkpath

    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    rvc requires to be installed in `/opt` and requires root privileges to start
    run:
    `sudo mkdir -m 500 -p /opt/rvc/bin /opt/rvc/etc/vpn.d`
    `sudo chown root:wheel -R /opt/rvc`
    `sudo install -m 500 -g wheel -o root /usr/local/bin/rvc /usr/local/bin/rvd /usr/local/bin/rvd.plist /opt/rvc/bin`
    `sudo install -m 500 -g wheel -o root /usr/local/etc/rvd.json /opt/rvc/etc`
    EOS
  end

  test do
    system "rvc", "--version"
  end
end
