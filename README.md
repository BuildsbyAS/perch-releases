# Perch releases

Builds of [Perch](https://github.com/BuildsbyAS/perch), the transit layer of your Mac.

**[Download Perch for macOS](https://github.com/BuildsbyAS/perch-releases/releases/latest/download/Perch.dmg)** · macOS 14 or later

## Installing

Paste this in Terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/BuildsbyAS/perch-releases/main/install.sh | sh
```

It downloads the latest Perch, checks it's signed with Perch's certificate, puts it in Applications and opens it. Run it again any time to reinstall. Requires an Apple Silicon Mac on macOS 14 or later.

Prefer the disk image? Open `Perch.dmg` and drag **Perch** onto **Applications**. Perch isn't notarized yet, so the first time macOS says it can't verify it: click **Done**, open **System Settings → Privacy & Security**, scroll down, click **Open Anyway**, and confirm.

After that, updates install themselves: when one is ready, click **Update to …** in the island or the menu bar icon.

## Publishing an update

Actions → **Release Perch** → **Run workflow**, then enter a version higher than the last one. The workflow builds the private source, signs it, and publishes a release here with:

- `Perch.dmg`, the download for new installs
- `Perch-<version>.zip`, the archive Sparkle installs
- `appcast.xml`, the feed every copy of Perch checks

Installed copies check `releases/latest/download/appcast.xml` every hour and whenever the island opens.
