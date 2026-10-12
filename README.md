# baroallgi

잘못된 정보로 바로 잡아주다!

- 앱·SDK·의존성 버전: [docs/VERSION_MANAGEMENT.md](docs/VERSION_MANAGEMENT.md)
- **iOS 시뮬레이터 (`flutter run`):** [docs/IOS_SIMULATOR.md](docs/IOS_SIMULATOR.md)

```bash
# iOS 시뮬레이터에 앱 실행 (권장)
./scripts/run_ios.sh
# 또는
flutter run -d "iPhone 18"
```

Cursor에서: `Cmd+Shift+D` → **`baroallgi · iPhone 18 (Run, no debug)`** → ▶  
(터치가 안 먹으면 `F5` Debug 대신 이 구성을 쓰세요. iOS 27 + 디버거 이슈)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## 🛠 Requirements (Xcode 27)

Xcode 27은 **iOS deployment target 15.0+** 와 **UIScene lifecycle** 이 필요합니다.

| 항목 | 권장 |
| --- | --- |
| Flutter | **3.47+** (stable) |
| Xcode | 27 |
| iOS minimum | 15.0 |

로컬 Flutter가 오래됐다면:

```bash
flutter upgrade
# 또는 https://docs.flutter.dev/install 에서 3.47+ 설치 후 PATH 교체
flutter doctor -v
```

`ios/` **소스**(Podfile, Runner, xcodeproj 등)는 git에 올립니다.  
`Pods/`, Flutter 생성 파일, `GoogleService-Info.plist` 만 ignore 합니다.

클론 후:

```bash
flutter pub get
cd ios && pod install
```

`ios/` 가 없거나 깨졌을 때만 재생성:

```bash
chmod +x scripts/setup_ios.sh
./scripts/setup_ios.sh
```

백업 템플릿: `tool/ios_xcode27/` (Xcode 27용 Podfile / Info.plist)

## 🛠 Local Setup (Android)

이 프로젝트는 보안 및 로컬 환경 설정을 위해 `android/local.dev.properties` 파일을 사용합니다.
처음 클론 받았다면 아래 절차를 따라주세요.

1. `android/` 폴더 안에 `local.properties` 파일을 생성합니다.
2. 아래 내용을 복사하여 파일에 넣고, 본인의 환경에 맞게 수정합니다.

```properties

# SDK 경로 (본인의 PC 경로에 맞게 수정)
sdk.dir=C:\\Users\\YOUR_NAME\\AppData\\Local\\Android\\sdk