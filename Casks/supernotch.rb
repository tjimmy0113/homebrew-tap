cask "supernotch" do
  version "0.1.3"
  sha256 "5b928541a84fad4f59dc97e6b0bfd007ca2bb5432be2a4851c28ed114d6cf292"

  url "https://github.com/tjimmy0113/supernotch/releases/download/v#{version}/SuperNotch-#{version}-arm64.dmg"
  name "SuperNotch"
  desc "Notch dynamic island for media, calendar, files and AI coding agents"
  homepage "https://github.com/tjimmy0113/supernotch"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "SuperNotch.app"

  # The app is ad-hoc signed (not notarized yet); clear the quarantine flag so
  # Gatekeeper doesn't block the first launch.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/SuperNotch.app"],
        writable_paths: ["{{appdir}}/SuperNotch.app"]
  end

  uninstall quit: "com.supernotch.app"

  # Only SuperNotch's own data. ~/.code-island and the hooks in
  # ~/.claude/settings.json / ~/.codex are shared with the Code Island app and
  # are intentionally left alone.
  zap trash: [
    "~/Library/Caches/com.supernotch.app",
    "~/Library/HTTPStorages/com.supernotch.app",
    "~/Library/Preferences/com.supernotch.app.plist",
  ]

  caveats <<~EOS
    On launch SuperNotch installs Claude Code / Codex hooks into
      ~/.claude/settings.json, ~/.codex/hooks.json and ~/.code-island/bin/
    (turn off in Settings -> AI Agents). Uninstalling does not remove them.

    Don't run SuperNotch together with the Code Island app.
  EOS
end
