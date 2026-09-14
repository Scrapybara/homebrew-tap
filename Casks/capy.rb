cask "capy" do
  arch arm: "arm64", intel: "x64"

  version "0.2.1"
  sha256 arm:   "2d0e553032487af114e62cb90cfc51f15cf64d23fe82b868998a005e923bdffd",
         intel: "9a6e3a91edc081adf9872b0a22acc388dadbefe710d73c63f6afe8e7fa3707b7"

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
