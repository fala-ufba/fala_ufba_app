# Fala UFBA

Onboarding guide for contributors using VS Code on macOS, Windows, and Linux. This project uses Flutter with FVM, Riverpod, Go Router, and Supabase.

## Prerequisites

Install the following before proceeding.

- VS Code and extensions
  - VS Code: see the official site
  - Extensions: Flutter and Dart
- Git
- Flutter via FVM (installed below)
- Android Studio (Android SDK, Platform Tools, and an emulator)
- macOS only: Xcode and Command Line Tools

Helpful references:
- Flutter install: [Flutter installation guide](https://docs.flutter.dev/get-started/install)
- VS Code extensions: [Flutter in VS Code](https://docs.flutter.dev/tools/vs-code)
- Android Studio: [Android Studio download](https://developer.android.com/studio)
- Xcode (macOS): via App Store

## Install FVM

FVM keeps your Flutter SDK version consistent across machines.

macOS with Homebrew:
```bash
brew tap leoafarias/fvm
brew install fvm
```

macOS/Linux via Dart pub:
```bash
dart pub global activate fvm
# ensure ~/.pub-cache/bin is on PATH
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc && source ~/.zshrc
```

Windows via Dart pub (PowerShell):
```powershell
dart pub global activate fvm
# add %USERPROFILE%\AppData\Local\Pub\Cache\bin to PATH in System Environment Variables
```

Verify:
```bash
fvm --version
```

## Clone and bootstrap

```bash
git clone https://github.com/your-org-or-user/fala_ufba.git
cd fala_ufba
fvm install
fvm use
fvm flutter doctor
fvm flutter pub get
```

Optional code generation (if you see @riverpod or build_runner usage):
```bash
fvm dart run build_runner build -d
```

## Environment variables (.env)

Create a `.env` file at the project root to store local secrets. An example is provided below.

1) Create `.env.example` with the required keys:
```env
SUPABASE_URL=
SUPABASE_PUB_KEY=
```

2) Copy and fill your local `.env`:
- macOS/Linux:
```bash
cp .env.example .env
```
- Windows (PowerShell):
```powershell
copy .env.example .env
```

3) `.env` is already ignored by Git
The repository `.gitignore` includes `.env`, so your local secrets will not be committed.

4) How this is used today
The app currently reads Supabase values from `lib/core/supabase_config.dart`. Keep your `.env` in sync and update that file locally with your values. A future improvement can load from `.env` at runtime using a package like `flutter_dotenv`.

## VS Code setup (uses FVM)

1) Install extensions: Flutter and Dart  
2) Point VS Code to the project Flutter SDK from FVM by creating `.vscode/settings.json`:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
```

3) Debug configuration: `.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Fala UFBA (Debug)",
      "request": "launch",
      "type": "dart",
      "toolArgs": ["--no-start-paused"]
    }
  ]
}
```

Select a device in the VS Code status bar, then press F5 to run.

## Running the app

List devices:
```bash
fvm flutter devices
```

Run on a specific device:
```bash
fvm flutter run -d <device-id>
```

### Web (Chrome)
```bash
fvm flutter run -d chrome
```

### Android (emulator)

1) Open Android Studio, install Android SDK, and create an AVD (Tools > Device Manager).  
2) From CLI:
```bash
flutter emulators
flutter emulators --launch <emulator-id>
fvm flutter run -d <emulator-id>
```

Windows notes:
- Ensure CPU virtualization is enabled in BIOS/UEFI.
- If the emulator is slow or fails, check Windows Features. The Android Emulator can use Windows Hypervisor Platform. If using WSL2/Hyper-V, follow the Emulator docs to avoid conflicts.

Linux notes:
- Enable KVM. Ensure your user is in the kvm group. See the Android Emulator Linux setup docs.

macOS notes:
- On Apple Silicon, use arm64 system images for better performance.

### iOS (macOS only, Simulator)

Install Xcode from the App Store and then run:
```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo xcodebuild -license accept
open -a Simulator
```

Run:
```bash
fvm flutter run -d ios
```

If CocoaPods is missing:
```bash
brew install cocoapods
```

## Troubleshooting

General:
```bash
fvm flutter doctor -v
```

Android:
```bash
fvm flutter doctor --android-licenses
fvm flutter clean && fvm flutter pub get
```

Gradle cache reset (if builds fail mysteriously):
```bash
rm -rf ~/.gradle/caches
```

iOS:
```bash
cd ios && pod install
```

Xcode path and first launch:
```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

## Common commands

```bash
fvm flutter pub get
fvm flutter run -d <device-id>
fvm flutter test
fvm dart run build_runner build -d
fvm flutter clean
```

## Project notes

- Flutter SDK version is pinned via `.fvmrc` (stable channel).
- VS Code launch configuration is provided in `.vscode/launch.json`.
- This app uses Supabase, Riverpod, and Go Router.
