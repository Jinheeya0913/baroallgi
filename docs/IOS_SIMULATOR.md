# iOS 시뮬레이터에서 테스트하기 (`flutter run`)

이 프로젝트는 **CLI로 시뮬레이터에 앱을 올리는 방식**을 기본으로 합니다.

```bash
flutter run
```

관련 문서: [VERSION_MANAGEMENT.md](./VERSION_MANAGEMENT.md)

---

## 빠른 실행 (일상)

프로젝트 루트에서:

```bash
# 최초 1회 또는 의존성 변경 후
flutter pub get
cd ios && pod install && cd ..

# 시뮬레이터에 앱 실행 (꺼져 있으면 자동 부팅)
flutter run
```

또는 래퍼 스크립트:

```bash
chmod +x scripts/run_ios.sh
./scripts/run_ios.sh
```

### Cursor에서 실행 (Run and Debug)

터미널 `flutter run -d "iPhone 18"` 와 동일하게 IDE에서 돌릴 수 있습니다.

1. **Dart** 확장 설치 (Flutter 포함)  
2. `Cmd + Shift + D` → Run and Debug  
3. 드롭다운에서 구성 선택 후 ▶ / `F5`

| 구성 | 용도 |
| --- | --- |
| **`baroallgi · iPhone 18 (Run, no debug)`** | **터치 테스트용 권장** (VM Service 디버거 미연결) |
| `baroallgi · iPhone 18 (Debug)` | 브레이크포인트 필요 시 (`F5`) |
| `baroallgi (current device)` | 상태바에 선택된 기기 |

설정: [`.vscode/launch.json`](../.vscode/launch.json)

> Xcode 27 / iOS 27 시뮬레이터에서 **Debug(`F5`)로 연결하면 UI는 보이는데 탭이 안 먹는** 경우가 있습니다.  
> 우선 **`(Run, no debug)`** 또는 터미널 `flutter run -d "iPhone 18"` 로 확인하세요.  
> (Run Without Debugging: `Cmd + F5` 도 동일하게 디버거를 안 붙입니다.)

| 상황 | 명령 / UI |
| --- | --- |
| Cursor 실행 (터치 OK) | `baroallgi · iPhone 18 (Run, no debug)` → ▶ |
| Cursor 디버그 | `baroallgi · iPhone 18 (Debug)` → `F5` |
| 터미널 | `flutter run -d "iPhone 18"` |
| hot reload | Debug 세션에서 저장 시 / 터미널 `r` |

`flutter run` 이 하는 일:

1. 사용 가능한 iOS 시뮬레이터 선택 (여러 개면 묻거나 `-d` 필요)
2. 꺼져 있으면 부팅
3. Xcode 27 환경이면 **Device Hub** UI로 시뮬레이터 창 표시
4. 앱 빌드·설치·실행

Device Hub를 따로 `open` 할 필요는 없습니다.

---

## 사전 요구사항

| 항목 | 권장 | 확인 |
| --- | --- | --- |
| Xcode | **27** | `xcodebuild -version` |
| Flutter | **3.47+** (stable) | `flutter --version` |
| CocoaPods | 1.16+ 권장 | `pod --version` |
| 시뮬레이터 런타임 | iOS 27 등 설치됨 | Xcode → Settings → Platforms |

```bash
flutter doctor -v
flutter devices
```

`flutter devices` 에 iOS Simulator(또는 iPhone …)가 보여야 합니다.

### Flutter lockfile / quarantine 오류

```bash
xattr -dr com.apple.quarantine "$(dirname "$(which flutter)")/.."
sudo chown -R "$(whoami)" "$(dirname "$(which flutter)")/../bin/cache"
flutter upgrade   # 3.47+
flutter doctor -v
```

---

## 최초 셋업

### 1) 의존성

```bash
flutter pub get
cd ios && pod install && cd ..
```

### 2) Firebase 로컬 파일 (gitignore)

앱 시작 시 Firebase를 쓰므로 아래가 **로컬에** 있어야 합니다.

| 파일 | 비고 |
| --- | --- |
| `lib/firebase_options.dart` | FlutterFire / 팀 공유 사본 |
| `ios/Runner/GoogleService-Info.plist` | Firebase 콘솔 iOS 앱 설정 |

없으면:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3) `ios/` 가 없거나 깨졌을 때만

```bash
./scripts/setup_ios.sh
```

---

## 기기 확인·지정

```bash
flutter devices
```

여러 대면:

```bash
flutter run -d "iPhone 17 Pro"
# 또는
flutter run -d <device_id>
```

---

## (참고) Xcode 27 · Device Hub

| Xcode | GUI 앱 |
| --- | --- |
| 26 이하 | Simulator (`open -a Simulator`) |
| **27+** | **Device Hub** (`open -a DeviceHub`) |

- 런타임 이름은 여전히 iOS Simulator 입니다.
- GUI 앱만 `Simulator.app` → `DeviceHub.app` 로 바뀌었습니다.
- **평소 테스트는 `flutter run` 만 쓰면 됩니다.** Device Hub는 창을 직접 보고 싶을 때만 엽니다.

```bash
open -a DeviceHub   # 선택 사항
```

네이티브 디버깅이 필요할 때만:

```bash
open ios/Runner.xcworkspace
# 스킴 Runner → iPhone 시뮬레이터 → Cmd+R
```

---

## 문제 해결

### 앱은 보이는데 터치 / 클릭이 안 됨

**1순위: Cursor Debug(`F5`) 대신 Run(no debug)으로 실행**

iOS 27 시뮬레이터 + IDE 디버거 연결 시, “Connected to VM Service” 이후  
화면은 떠 있어도 탭이 먹통이 되는 사례가 있습니다.

- Run and Debug → **`baroallgi · iPhone 18 (Run, no debug)`** → ▶  
- 또는 `Cmd + F5` (Run Without Debugging)  
- 또는 터미널: `flutter run -d "iPhone 18"`

**2순위: 시뮬레이터 포커스**

1. Device Hub 창을 한 번 클릭  
2. 버튼 **ripple** 여부 확인 (없으면 포커스/입력 경로 문제)  
3. 가능하면 **iOS 26.x** 시뮬레이터로도 비교  

```bash
flutter devices
flutter run -d "<iOS 26 기기명>"
```

### `flutter devices` 에 시뮬레이터 없음

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
# Xcode → Settings → Platforms 에서 iOS runtime 설치
open -a DeviceHub
flutter doctor -v
```

### deployment target / UIScene

- `ios/Podfile` → `platform :ios, '15.0'`
- `SceneDelegate` + Info.plist `UIApplicationSceneManifest` 존재 여부

### Firebase 초기화 실패

`firebase_options.dart` / `GoogleService-Info.plist` 배치 확인.

### 캐시 꼬임

```bash
flutter clean
flutter pub get
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
flutter run
```

### CocoaPods 오류

```bash
cd ios && pod install --repo-update
```

---

## 체크리스트

- [ ] Flutter ≥ 3.47, Xcode 27  
- [ ] `flutter doctor -v` 통과  
- [ ] `flutter pub get` + `pod install`  
- [ ] Firebase 로컬 파일 배치  
- [ ] `flutter devices` 에 시뮬레이터 보임  
- [ ] **`flutter run`** (또는 `./scripts/run_ios.sh`)

---

## 변경 이력

| 날짜 | 내용 |
| --- | --- |
| 2026-10-10 | 초안 |
| 2026-10-10 | Device Hub 명칭 반영 |
| 2026-10-10 | **`flutter run` 중심**으로 재구성, `scripts/run_ios.sh` 안내 |
| 2026-10-10 | 터치 미동작(Device Hub 포커스 / iOS 27) 트러블슈팅 추가 |
