# Perch releases

Builds of [Perch](https://github.com/BuildsbyAS/perch), the transit layer of your Mac.

**[Download Perch for macOS](https://github.com/BuildsbyAS/perch-releases/releases/latest/download/Perch.dmg)** · macOS 14 or later

## Installing

1. Open `Perch.dmg` and drag **Perch** onto **Applications**.
2. Open Perch from Applications. The first time, macOS says it can't verify the developer: open **System Settings → Privacy & Security**, scroll down, click **Open Anyway** next to Perch, and confirm.
3. After that, updates install themselves: when one is ready, click **Update to …** in the island or the menu bar icon.

## Publishing an update

Actions → **Release Perch** → **Run workflow**, then enter a version higher than the last one. The workflow builds the private source, signs it, and publishes a release here with:

- `Perch.dmg`, the download for new installs
- `Perch-<version>.zip`, the archive Sparkle installs
- `appcast.xml`, the feed every copy of Perch checks

Installed copies check `releases/latest/download/appcast.xml` every hour and whenever the island opens.
