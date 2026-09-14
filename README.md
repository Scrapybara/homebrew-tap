# Scrapybara Homebrew tap

Homebrew packages for [Capy](https://capy.ai/).

## macOS

Install the desktop app on macOS 13 or later:

```sh
brew install --cask scrapybara/tap/capy
```

```sh
brew upgrade --cask capy
```

The macOS app also updates itself in place, so `brew upgrade` keeps Homebrew's version bookkeeping current.

## Linux

Install the desktop app on x86_64 or ARM64 Linux with [Homebrew](https://brew.sh/):

```sh
brew install --formula scrapybara/tap/capy
capy
```

The formula installs the published stable AppImage's unpacked contents, not a command-line-only client. Extraction uses Homebrew's `squashfs` without executing the AppImage runtime, so it needs neither FUSE nor an architecture-matching runtime during extraction. Run Capy as your normal user in an X11 or Wayland graphical desktop session, not as root or on a headless server.

The desktop app needs system GTK 3, NSS, ALSA, GBM, and X11 libraries. On Ubuntu 24.04, install the runtime libraries and optional desktop integration tools with:

```sh
sudo apt install libgtk-3-0t64 libnss3 libasound2t64 libgbm1 libxss1 libxtst6 libnotify4 xdg-utils desktop-file-utils
```

Package names vary by distribution; older Debian/Ubuntu releases use `libgtk-3-0` and `libasound2`. A working D-Bus desktop session is also needed for desktop integration. Chromium's sandbox requires unprivileged user namespaces permitted by your kernel and distribution security policy. If the app reports sandbox or namespace errors, ask your administrator to configure support for the installed executable; do not disable the sandbox. The formula neither passes `--no-sandbox` nor installs a privileged sandbox helper.

### Updates

```sh
brew update
brew upgrade --formula scrapybara/tap/capy
```

Homebrew owns Linux updates. The launcher clears inherited `APPIMAGE` and `APPDIR` variables and runs the unpacked executable directly, preventing the AppImage updater from replacing Homebrew-managed files. The installed resources also include an empty `homebrew-managed` marker for Capy's package-manager detection. Quit and reopen Capy after upgrading.

### Application menu and capy:// links

The formula installs a desktop entry and icons under Homebrew's `share` directory. Its launcher and icon paths use the stable Homebrew `opt` location, so they keep working after upgrades. The formula does not write to your home directory or change your default URL handler.

To register Capy for your desktop user, run the following without `sudo` from your graphical session. These commands require `desktop-file-utils` and `xdg-utils`:

```sh
applications="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
mkdir -p "$applications"
ln -s "$(brew --prefix capy)/share/applications/capy.desktop" "$applications/capy.desktop" &&
  update-desktop-database "$applications" &&
  xdg-mime default capy.desktop x-scheme-handler/capy
xdg-mime query default x-scheme-handler/capy
```

The final command should print `capy.desktop`. This makes browser sign-in callbacks and other `capy://` links open the Homebrew installation. It replaces any previous default handler for that scheme; note the previous handler first if you want to restore it later. The desktop filename matches Capy's Wayland application identity for window grouping.

Do not mix Capy installation formats. If `capy.desktop` already exists in your user applications directory, the symlink command refuses to overwrite it and skips registration. Resolve the previous installation's desktop entry first, then rerun these commands. System-wide Capy entries from another package can also conflict; remove the old package before switching to Homebrew.

### Uninstall and desktop cleanup

Remove the manually created desktop entry before uninstalling:

```sh
applications="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
if [ "$(readlink "$applications/capy.desktop")" = "$(brew --prefix capy)/share/applications/capy.desktop" ]; then
  rm "$applications/capy.desktop"
  update-desktop-database "$applications"
fi
brew uninstall --formula capy
```

The cleanup only removes a symlink pointing to this Homebrew installation, leaving any replacement desktop entry alone. If another Capy installation should handle links, restore its desktop entry with `xdg-mime default OTHER.desktop x-scheme-handler/capy`. Otherwise, remove `capy.desktop` from the `x-scheme-handler/capy` entries in `${XDG_CONFIG_HOME:-$HOME/.config}/mimeapps.list` and any desktop-specific `*-mimeapps.list` there, and in `${XDG_DATA_HOME:-$HOME/.local/share}/applications/mimeapps.list` if present. Preserve other handlers in those entries. Homebrew cannot remove these user-created associations for you.

Uninstalling does not delete Capy's user data in `${XDG_CONFIG_HOME:-$HOME/.config}/Capy`; keep it for a later reinstall, or remove it separately if you no longer need it.
