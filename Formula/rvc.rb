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

    # We're creating the plist manually now
    # prefix.install "plist/com.ribose.rvd.plist"
    # (prefix+"com.ribose.rvd.plist").chmod 0644

    # Replace user 501 with current installing user
    inreplace "conf/rvd.json", "501", `id -u`
		(etc/"rvd").install "conf/rvd.json"
  end

  plist_options startup: false

  def plist; <<-EOS.undent
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <dict>
      <key>SuccessfulExit</key>
      <false/>
    </dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{target_prefix}/bin/rvd</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>/tmp</string>
    <key>StandardErrorPath</key>
    <string>/var/log/rvd.log</string>
    <key>StandardOutPath</key>
    <string>/var/log/rvd.log</string>
  </dict>
</plist>
    EOS
  end

  # This is where we want the rvc binary to reside
  def target_prefix
    "/opt/rvc"
  end

  # This is where we want the openvpn binary to reside
	def opt_openvpn
		"/opt/openvpn"
	end

  # Override plist_name to com.ribose namespace
	def plist_name
		"com.ribose.rvd"
	end

  def caveats; <<-EOS.undent
    rvc requires to be installed in `/opt` and requires root privileges to start
    run:
      sudo mkdir -m 500 -p #{target_prefix}/bin #{target_prefix}/etc/vpn.d #{opt_openvpn}/sbin
      sudo chown -R root:wheel #{target_prefix} #{opt_openvpn}/
      sudo install -m 500 -g wheel -o root #{bin/"rvc"} #{bin/"rvd"} #{target_prefix}/bin
      sudo install -m 500 -g wheel -o root #{etc/"rvd.json"} #{target_prefix}/etc
      #sudo install -m 500 -g wheel -o root #{prefix/(plist_name+".plist")} /Library/LaunchDaemons
      sudo install -m 500 -g wheel -o root #{Formula["openvpn"].opt_sbin}/openvpn #{opt_openvpn}/sbin

    To load #{name} at startup, activate the included LaunchDaemon:

    If this is your first install, automatically load on startup with:
      sudo install -m 500 -g wheel -o root #{prefix}/com.ribose.rvd.plist /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/com.ribose.rvd.plist

    If this is an upgrade and you already have the plist loaded:
      sudo launchctl unload -w /Library/LaunchDaemons/com.ribose.rvd.plist
      sudo install -m 500 -g wheel -o root #{prefix}/com.ribose.rvd.plist /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/com.ribose.rvd.plist
    EOS
  end

  test do
    system "rvc", "--version"
  end
end
