#!/usr/bin/env bash
# Xcode 27 / iOS 27 대응 iOS 플랫폼 생성 스크립트
# 요구사항: Flutter 3.47+ (iOS minimum 15.0, UIScene)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter 명령을 찾을 수 없습니다. Flutter 3.47+ 를 PATH에 추가하세요."
  exit 1
fi

FLUTTER_VERSION="$(flutter --version 2>/dev/null | head -1 || true)"
echo "Using: $FLUTTER_VERSION"

MAJOR_MINOR="$(flutter --version 2>/dev/null | sed -n 's/^Flutter \([0-9]*\.[0-9]*\).*/\1/p' | head -1)"
MAJOR="${MAJOR_MINOR%%.*}"
MINOR="${MAJOR_MINOR#*.}"
if [[ -z "$MAJOR" || -z "$MINOR" ]] || (( MAJOR < 3 || (MAJOR == 3 && MINOR < 47) )); then
  echo "Xcode 27 지원을 위해 Flutter 3.47+ 가 필요합니다. 현재: ${FLUTTER_VERSION:-unknown}"
  echo "예: flutter upgrade   또는  https://docs.flutter.dev/install 참고"
  exit 1
fi

flutter create . --platforms=ios --project-name=baroallgi --org=com.baroallgi

TEMPLATE_DIR="$ROOT/tool/ios_xcode27"
cp "$TEMPLATE_DIR/Podfile" "$ROOT/ios/Podfile"
cp "$TEMPLATE_DIR/Info.plist" "$ROOT/ios/Runner/Info.plist"

flutter pub get
(cd ios && pod install)

echo
echo "iOS 설정 완료 (deployment target 15.0, UIScene, permission Info.plist)."
echo "다음: open ios/Runner.xcworkspace"
