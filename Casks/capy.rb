cask "capy" do
  arch arm: "arm64", intel: "x64"

  version "0.3.0"
  sha256 arm:   "35930dcfa714d85e6a7c7131623c5243dbf64034bef93c8d19e29458c553955a",
         intel: "2c0db5c0bd4f30d43754c8c803764108687eab52128b6add7ffe96e913f4b3ff"

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
