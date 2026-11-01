cask "capy" do
  arch arm: "arm64", intel: "x64"

  version "0.7.2"
  sha256 arm:   "142afaf54ba18a1ba4d7655fe790f12454a015c7e384e3e36b139a7958295649",
         intel: "dd337a7a92bc281b54849cd07b21cf8aff9a153d4ab2ddf8531d040d0f3322a2"

  url "https://downloads.capy.ai/stable/Capy-#{version}-#{arch}.dmg"
  name "Capy"
  desc "AI software engineer that plans, builds, and ships with parallel coding agents"
  homepage "https://capy.ai/"

  livecheck do
    url "https://downloads.capy.ai/stable/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: :ventura

  app "Capy.app"

  zap trash: [
    "~/Library/Application Support/Capy",
    "~/Library/Caches/ai.capy.desktop",
    "~/Library/Caches/ai.capy.desktop.ShipIt",
    "~/Library/HTTPStorages/ai.capy.desktop",
    "~/Library/Preferences/ai.capy.desktop.plist",
    "~/Library/Saved Application State/ai.capy.desktop.savedState",
  ]
end
