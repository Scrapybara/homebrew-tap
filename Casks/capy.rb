cask "capy" do
  arch arm: "arm64", intel: "x64"

  version "0.9.2"
  sha256 arm:   "07ffb38d169e15423bfd6e4b2a0002f800799e37465b2cc404c3a3f88cb22ad0",
         intel: "433d883743650aea2a7f87c8c3ea2f893b395cc810187d33be3e81ef762f90b2"

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
