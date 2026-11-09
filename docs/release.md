# Release

Mane ships from GitHub Releases. Obtainium can follow the repository, and the
Linux bundle is published next to the APKs. F-Droid, IzzyOnDroid and OpenAPK are
optional and only after the GitHub release is stable.

The release workflow is `.github/workflows/release.yml`. It runs on a `v*` tag,
runs both test suites, builds split APKs and the Linux bundle, and publishes
them with `SHA256SUMS`.

## Version

Before tagging:

1. Update `version:` in `pubspec.yaml`, for example `0.5.0+5`. The build number
   must increase for every Android release.
2. Update `lib/app_version.dart` to the same semantic version, without the build
   number.
3. Update the status line in `README.md` and `docs/full-docs.md`.
4. Run the full gate from `AGENTS.md`.

## Android signing

Release signing is a user-provided step. The repository ships no key and no
password. A debug-signed build is not a production release.

Create the key once and keep it outside the repository:

```bash
keytool -genkey -v \
  -keystore ~/keys/mane-release.jks \
  -keyalg RSA -keysize 4096 -validity 10000 -alias mane
```

`android/key.properties` is gitignored. For a local release build:

```properties
storePassword=...
keyPassword=...
keyAlias=mane
storeFile=/home/you/keys/mane-release.jks
```

The Gradle file uses this file when it exists and falls back to the debug key
otherwise, so local release builds stay runnable during development.

For CI, add these repository secrets:

- `ANDROID_KEYSTORE_BASE64`: `base64 -w0 ~/keys/mane-release.jks`
- `ANDROID_STORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

The workflow refuses to publish a release without the keystore secret.

## Local commands

```bash
flutter build apk --release --split-per-abi
flutter build linux --release
sha256sum build/app/outputs/flutter-apk/app-*-release.apk
```

APK outputs:

- `app-armeabi-v7a-release.apk`
- `app-arm64-v8a-release.apk`
- `app-x86_64-release.apk`

The Linux bundle is `build/linux/x64/release/bundle/`. Archive it with:

```bash
tar -czf mane-linux-x64.tar.gz -C build/linux/x64/release/bundle .
```

## Tag and publish

```bash
git tag -a v0.5.0 -m "Mane 0.5.0"
git push origin v0.5.0
```

The workflow publishes the APKs, the Linux archive and `SHA256SUMS`. Check the
release page, install the arm64 APK on the device, and verify that the About
screen shows the same version.

## Obtainium

Point Obtainium at the GitHub repository and use the release assets. Prefer the
`arm64-v8a` APK for modern phones. The version code comes from the `+N` build
number in `pubspec.yaml`.

## F-Droid and other stores (optional)

There is no store metadata in the repository yet. If the project is submitted:

- License: GPL-3.0-only, with the attribution terms in `ADDITIONAL_TERMS.md`.
- No accounts, ads, tracking, telemetry or non-free dependencies.
- F-Droid requires a reproducible build from a tagged source archive and its own
  signing key. Do not reuse the developer keystore for F-Droid.
- The package id is `io.github.gabrieleancillai.mane` and must not change.

## Release checklist

- [ ] `flutter analyze --no-fatal-infos` is clean.
- [ ] `flutter test` and `(cd packages/mane_core && dart test)` pass.
- [ ] Both debug builds pass before the release build.
- [ ] Version and build number are bumped.
- [ ] The release APK is signed with the user's key, not the debug key.
- [ ] `SHA256SUMS` matches the uploaded files.
- [ ] The About screen shows the license and upstream attribution.
- [ ] Backup export/import was tried on the release build.
- [ ] The real-device notification checklist was run.
