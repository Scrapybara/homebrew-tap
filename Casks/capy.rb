cask "capy" do
  arch arm: "arm64", intel: "x64"

  version "0.5.0"
  sha256 arm:   "6b2b79b70813f46302d3ecd20ce7dd170a971572712af66b22f8b4024d7ae27a",
         intel: "84f1eb10bc270356c4a4a1820af065dceedc0c7c7a06deb40d33030351178ddc"

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
