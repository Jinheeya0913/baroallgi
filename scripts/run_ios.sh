#!/usr/bin/env bash
# iOS 시뮬레이터에 flutter run 으로 앱 실행 (Xcode 27 = Device Hub UI)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter 를 PATH 에서 찾을 수 없습니다."
  exit 1
fi

echo "==> flutter --version"
flutter --version | head -3

# 선택: 첫 인자로 device id / 이름 전달 → flutter run -d ...
DEVICE_ARGS=()
if [[ $# -gt 0 ]]; then
  DEVICE_ARGS=(-d "$1")
  shift
fi

if [[ ! -f lib/firebase_options.dart ]]; then
  echo "오류: lib/firebase_options.dart 가 없습니다. (gitignore 대상)"
  echo "팀 사본을 넣거나: dart pub global activate flutterfire_cli && flutterfire configure"
  exit 1
fi

if [[ ! -f ios/Runner/GoogleService-Info.plist ]]; then
  echo "경고: ios/Runner/GoogleService-Info.plist 가 없습니다. Firebase iOS 설정이 필요할 수 있습니다."
fi

echo "==> flutter pub get"
flutter pub get

if [[ -f ios/Podfile ]]; then
  echo "==> pod install"
  (cd ios && pod install)
fi

echo "==> flutter devices (iOS)"
flutter devices

echo "==> flutter run ${DEVICE_ARGS[*]:-} $*"
# 시뮬레이터가 꺼져 있으면 부팅 후 Device Hub 창으로 실행
exec flutter run "${DEVICE_ARGS[@]}" "$@"
