class Rvc < Formula
  desc "RVC: Relaxed VPN Client"
  homepage "https://github.com/riboseinc/rvc"
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
    system './build_macos.sh'
    system "make", "install"

    # prefix.install "plist/com.ribose.rvd.plist"
    # (prefix+"com.ribose.rvd.plist").chmod 0644
    inreplace "conf/rvd.json", /501/, `id -u`.chomp
    require 'fileutils'
    require 'pp'
    FileUtils.rm(etc/"rvd/rvd.json") if File.exists?(etc/"rvd/rvd.json")
    (etc/"rvd").install "conf/rvd.json"
  end

  plist_options startup: false

  def target_prefix
    "/opt/rvc"
  end

  def opt_openvpn
    "/opt/openvpn"
  end

  def plist_name
    "com.ribose.rvd"
  end

  def caveats; <<-EOS.undent
    rvd and rvc requires to be installed in `/opt`
    run:
      sudo mkdir -m 755 -p #{target_prefix}/bin #{opt_openvpn}/sbin
      sudo mkdir -m 755 -p #{target_prefix}/etc/vpn.d
      sudo chown -R root:wheel #{target_prefix} #{opt_openvpn}/
      sudo install -m 500 -g wheel -o root #{bin/"rvd"} #{target_prefix}/bin
      sudo install -m 555 -g wheel -o root #{bin/"rvc"} #{target_prefix}/bin
      sudo install -m 600 -g wheel -o root #{etc/"rvd/rvd.json"} #{target_prefix}/etc
      sudo install -m 500 -g wheel -o root #{Formula["openvpn"].opt_sbin}/openvpn #{opt_openvpn}/sbin

    Ensure that `/opt/rvc/bin` is in your PATH and is set before `/usr/local/bin`. E.g.:
      PATH=/opt/rvc/bin:/usr/local/bin

    To load #{name} at startup, activate the included LaunchDaemon:

    If this is your first install, automatically load on startup with:
      sudo install -m 600 -g wheel -o root #{prefix/(plist_name+".plist")} /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/#{plist_name}.plist

    If this is an upgrade and you already have the plist loaded:
      sudo launchctl unload /Library/LaunchDaemons/#{plist_name}.plist
      sudo install -m 600 -g wheel -o root #{prefix/(plist_name+".plist")} /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/#{plist_name}.plist

    EOS
  end

  test do
    system "rvc", "--version"
  end
end
