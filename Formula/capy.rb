class Capy < Formula
  desc "AI software engineer that plans, builds, and ships with parallel coding agents"
  homepage "https://capy.ai/"
  version "0.2.1"
  license :cannot_represent

  if Hardware::CPU.arm?
    url "https://downloads.capy.ai/stable/capy-#{version}-arm64.AppImage"
    sha256 "74ea530975e9386ada5ce6408bc2056231d2d1fc2771d9f868ef9ff55ed2e357"
  else
    url "https://downloads.capy.ai/stable/capy-#{version}-x86_64.AppImage"
    sha256 "4167352b7ad4200a0f5805b89209738600fefb1b26d22ab7fbc97fcd099763ff"
  end

  depends_on "squashfs" => :build
  depends_on :linux

  def install
    appimage = Dir["*.AppImage"].first
    header = File.binread(appimage, 64)
    odie "Expected a little-endian ELF64 AppImage" unless header.start_with?("\x7fELF\x02\x01")

    section_offset = header.unpack1("@40Q<")
    section_size, section_count = header.unpack("@58v2")
    last_section = File.binread(appimage, 16, section_offset + (section_size * (section_count - 1)) + 24)
    offset = [section_offset + (section_size * section_count), last_section.unpack("Q<2").sum].max
    odie "AppImage SquashFS payload not found" if File.binread(appimage, 4, offset) != "hsqs"

    system "#{formula_opt_bin("squashfs")}/unsquashfs", "-offset", offset.to_s,
           "-dest", "appdir", appimage
    libexec.install (buildpath/"appdir").children
    foreign_arch = Hardware::CPU.arm? ? "x64" : "arm64"
    foreign_prebuild = libexec/"resources/node_modules/tree-sitter-bash/prebuilds/linux-#{foreign_arch}"
    rm_r foreign_prebuild if foreign_prebuild.directory?
    (libexec/"resources/homebrew-managed").write ""

    (bin/"capy").write <<~SH
      #!/bin/sh
      unset APPIMAGE APPDIR
      export LD_LIBRARY_PATH="#{libexec}/usr/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec "#{libexec}/capy" "$@"
    SH

    (share/"icons").install_symlink libexec/"usr/share/icons/hicolor"
    (share/"applications/capy.desktop").write <<~DESKTOP
      [Desktop Entry]
      Name=Capy
      Comment=Capy runs your coding agents in the cloud.
      Exec="#{opt_bin}/capy" %U
      Terminal=false
      Type=Application
      Icon=#{opt_share}/icons/hicolor/512x512/apps/capy.png
      StartupWMClass=capy
      MimeType=x-scheme-handler/capy;
      Categories=Development;
    DESKTOP
  end

  def caveats
    <<~EOS
      Launch Capy with `capy` from a Linux graphical desktop session.
      System GTK 3, NSS, ALSA, GBM and X11 libraries must be installed.
      Chromium sandboxing requires working unprivileged user namespaces;
      this formula does not disable the sandbox or install a privileged helper.
      Homebrew owns updates: brew upgrade --formula scrapybara/tap/capy

      To add the application menu entry and handle capy:// links for your user:
        applications="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
        mkdir -p "$applications"
        ln -s "#{opt_share}/applications/capy.desktop" "$applications/capy.desktop" &&
          update-desktop-database "$applications" &&
          xdg-mime default capy.desktop x-scheme-handler/capy

      These commands require desktop-file-utils and xdg-utils. Run them as
      your desktop user, without sudo. Homebrew does not modify your home.
      Do not mix Capy installation formats. If capy.desktop already exists,
      resolve that installation's desktop entry before registering this one.
      Before uninstalling, remove only this installation's user symlink and
      its capy.desktop associations from your mimeapps.list files.
      See the tap README for system packages and complete cleanup commands.
    EOS
  end

  test do
    assert_path_exists libexec/"resources/homebrew-managed"
    assert_predicate libexec/"resources/homebrew-managed", :zero?
    assert_path_exists share/"applications/capy.desktop"
    assert_path_exists share/"icons/hicolor/512x512/apps/capy.png"
    assert_path_exists libexec/"capy.png"

    (testpath/"launcher.js").write <<~JS
      const assert = require('node:assert/strict');
      assert.equal(process.env.APPIMAGE, undefined);
      assert.equal(process.env.APPDIR, undefined);
      assert.equal(process.execPath, '#{libexec}/capy');
      assert.deepEqual(process.argv.slice(2), ['argument with spaces', 'capy://test']);
      assert.equal(require('#{libexec}/resources/node_modules/tree-sitter-bash').name, 'bash');
    JS
    ENV["ELECTRON_RUN_AS_NODE"] = "1"
    ENV["APPIMAGE"] = "/inherited.AppImage"
    ENV["APPDIR"] = "/inherited-appdir"
    system bin/"capy", testpath/"launcher.js", "argument with spaces", "capy://test"
  end
end
