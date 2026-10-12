# 버전 관리 가이드

이 문서는 baroallgi에서 **앱 버전·SDK·의존성·네이티브 설정**을 효율적으로 관리하기 위해  
주기적으로 확인·수정해야 하는 파일을 정리합니다.

---

## 1. 한눈에 보는 파일 맵

| 우선순위 | 파일 | 역할 | 커밋 여부 |
| --- | --- | --- | --- |
| P0 | `pubspec.yaml` | 앱 버전, Dart SDK 범위, 패키지 선언 | ✅ |
| P0 | `pubspec.lock` | 실제 해석된 패키지 버전(팀 고정) | ✅ |
| P0 | `.metadata` | 프로젝트 생성/마이그레이션 기준 Flutter revision | ✅ |
| P1 | `ios/Podfile` | iOS 최소 타깃·팟 post_install | ✅ |
| P1 | `ios/Podfile.lock` | CocoaPods 해석 결과 (있으면 커밋 권장) | ✅ |
| P1 | `ios/Runner/**` | AppDelegate, SceneDelegate, Info.plist, 자산 | ✅ |
| P1 | `ios/Runner.xcodeproj/**` | 프로젝트·스킴 설정 | ✅ |
| P1 | `tool/ios_xcode27/*` | 재생성 시 참고용 백업 템플릿 | ✅ |
| P1 | `scripts/setup_ios.sh` | `ios/` 재생성 + 템플릿 적용 | ✅ |
| P1 | `android/app/build.gradle.kts` | Android min/target/compile SDK 연동 | ✅ |
| P1 | `android/settings.gradle.kts` | AGP / Kotlin / Google Services 플러그인 버전 | ✅ |
| P1 | `android/gradle/wrapper/gradle-wrapper.properties` | Gradle Wrapper 버전 | ✅ |
| P2 | `analysis_options.yaml` | 린트/분석 규칙 | ✅ |
| P2 | `README.md` | 로컬 요구사항(Flutter/Xcode) 안내 | ✅ |
| — | `ios/Pods/`, `ios/Flutter/Generated.*`, `ephemeral/` | 로컬 생성물 | ❌ |
| — | `GoogleService-Info.plist` | Firebase 시크릿 | ❌ |
| — | `android/local.properties` | 기기별 SDK 경로 | ❌ |

> `ios/` **소스**(Podfile, Runner, xcodeproj 등)는 커밋합니다.  
> `Pods/`, Flutter 생성 파일, Firebase plist 만 `ios/.gitignore` 로 제외합니다.

---

## 2. 관리 축별 상세

### 2.1 앱 버전 (스토어 / 빌드)

**파일:** `pubspec.yaml` → `version: x.y.z+build`

```yaml
version: 1.0.0+1
#          │     └─ build number (Android versionCode / iOS CFBundleVersion)
#          └─ version name (Android versionName / iOS CFBundleShortVersionString)
```

| 언제 | 무엇을 |
| --- | --- |
| 기능 출시 / 핫픽스 | `x.y.z` 올리기 |
| 같은 버전으로 재업로드 | `+build` 만 올리기 |
| CI/배포 | `--build-name` / `--build-number` 로 덮어쓰기 가능 |

**주기:** 릴리스마다. 평소엔 변경 없음.

---

### 2.2 Flutter / Dart SDK

| 확인 명령 | 보는 곳 |
| --- | --- |
| `flutter --version` | 로컬 SDK |
| `flutter doctor -v` | Xcode / Android toolchain 호환 |
| `pubspec.yaml` → `environment.sdk` | Dart 언어 범위 (예: `^3.10.8`) |
| `.metadata` → `version.revision` | 프로젝트 기준 Flutter revision |

**현재 권장 (Xcode 27 기준)**

| 항목 | 권장 |
| --- | --- |
| Flutter | **3.47+** (stable) |
| Xcode | 27 |
| iOS minimum | **15.0** |

| 언제 손대나 | 행동 |
| --- | --- |
| Xcode 메이저 업데이트 | `flutter doctor`, iOS 최소 타깃, `tool/ios_xcode27/` 점검 |
| Flutter stable 업그레이드 | `flutter upgrade` → `flutter pub get` → 빌드 스모크 |
| Dart constraint 불일치 | `pubspec.yaml`의 `environment.sdk` 조정 |

**주기:**  
- 매 스프린트/월 1회 `flutter doctor -v`  
- Xcode·Flutter 메이저 릴리스 직후 즉시

---

### 2.3 Dart 패키지 의존성

**파일:** `pubspec.yaml` (선언) + `pubspec.lock` (고정)

| 명령 | 용도 |
| --- | --- |
| `flutter pub outdated` | 업그레이드 가능 목록 |
| `flutter pub upgrade` | constraint 안에서의 최신화 |
| `flutter pub upgrade --major-versions` | major 포함 갱신(신중) |
| `flutter pub get` | lock 기준 설치 |

**특히 주시할 패키지 (네이티브/권한 영향 큼)**

- `firebase_*`, `cloud_firestore`, `firebase_storage`
- `permission_handler`, `camera`, `photo_manager`
- `flutter_secure_storage`, `device_info_plus`
- `flutter_quill` / `flutter_quill_extensions`

| 규칙 | 설명 |
| --- | --- |
| lock 커밋 | 팀·CI가 같은 버전을 쓰도록 `pubspec.lock` 항상 커밋 |
| major 업 | README/changelog 확인 후, iOS·Android 빌드까지 검증 |
| Firebase | FlutterFire 버전끼리 세트가 맞는지 확인 |

**주기:** 격주~월 1회 `flutter pub outdated` 확인. 보안/브레이킹 이슈 시 즉시.

---

### 2.4 iOS / Xcode

**커밋 O (소스)**

| 경로 | 내용 |
| --- | --- |
| `ios/Podfile` | `platform :ios, '15.0'`, 팟 deployment 강제, permission 매크로 |
| `ios/Podfile.lock` | `pod install` 후 생기며, 있으면 커밋 권장 |
| `ios/Runner/` | AppDelegate, SceneDelegate, Info.plist, 아이콘/런치 |
| `ios/Runner.xcodeproj/`, `ios/Runner.xcworkspace/` (공유 설정) | 타깃·스킴 |
| `ios/Flutter/Debug.xcconfig`, `Release.xcconfig`, `AppFrameworkInfo.plist` | 고정 xcconfig |

**커밋 X (생성물·시크릿)** — `ios/.gitignore` 가 담당

| 경로 | 이유 |
| --- | --- |
| `ios/Pods/`, `ios/.symlinks/` | `pod install` 로 재생성 |
| `ios/Flutter/Generated.xcconfig`, `ephemeral/`, `Flutter.podspec` | `flutter pub get` / 빌드 시 생성 |
| `Runner/GeneratedPluginRegistrant.*` | Flutter 도구가 재생성 |
| `GoogleService-Info.plist` | Firebase 시크릿 |
| `xcuserdata/` | 개인 Xcode 설정 |

`tool/ios_xcode27/` + `scripts/setup_ios.sh` 는 **ios를 날리고 다시 만들 때** 쓰는 백업/복구용입니다.  
평소 수정은 `ios/Podfile`, `ios/Runner/Info.plist` 를 직접 고치고 커밋하세요.

**클론 후 iOS 준비**

```bash
flutter pub get
cd ios && pod install
# 또는 (ios가 없거나 깨졌을 때만)
./scripts/setup_ios.sh
```

| 주기적으로 볼 포인트 | 파일/위치 |
| --- | --- |
| 최소 iOS 버전 | `ios/Podfile` / `project.pbxproj` 의 `IPHONEOS_DEPLOYMENT_TARGET` |
| UIScene | `SceneDelegate` + Info.plist `UIApplicationSceneManifest` |
| 권한 문구 | Info.plist `NS*UsageDescription` |
| 낮은 타깃 팟 | `photo_manager` 등 → Podfile `post_install` 유지 |

**주기:** Xcode 업데이트 직후, Firebase/카메라/권한 패키지 major 업 직후.

---

### 2.5 Android

| 파일 | 볼 것 |
| --- | --- |
| `android/app/build.gradle.kts` | `minSdk` / `targetSdk` / `compileSdk` (Flutter 값 연동) |
| `android/settings.gradle.kts` | AGP, Kotlin, `google-services` 버전 |
| `android/gradle/wrapper/gradle-wrapper.properties` | Gradle 버전 |
| `android/local.dev.properties` | 로컬용 템플릿(안내용) |
| `android/local.properties` | 로컬만 (gitignore) |

**주기:** Flutter 업그레이드 후, AGP/Kotlin 경고 뜰 때, Play 정책(targetSdk) 변경 시.

---

### 2.6 기타

| 파일 | 언제 |
| --- | --- |
| `analysis_options.yaml` | Dart/린트 메이저 변경, `flutter_lints` 업 시 |
| `.gitignore` | 플랫폼/시크릿 경로 정책 변경 시 |
| `README.md` | 최소 Flutter·Xcode 요구사항이 바뀔 때 |

---

## 3. 권장 점검 루틴

### 매주 (가볍게)

```bash
flutter doctor -v
flutter pub outdated
```

### 매 릴리스 전

1. `pubspec.yaml` 의 `version` 갱신  
2. `flutter pub get`  
3. Android / iOS 스모크 빌드  
4. (iOS) 필요 시 `./scripts/setup_ios.sh` 후 `pod install`

### Xcode / Flutter 메이저 업 직후 (체크리스트)

- [ ] `flutter --version` ≥ 권장(현재 3.47+)
- [ ] `flutter doctor` 에 Xcode / CocoaPods 이상 없음
- [ ] `ios/Podfile` 의 `platform :ios` ≥ Xcode 최소(현재 15.0)
- [ ] 필요 시 `tool/ios_xcode27/` 템플릿도 동기화
- [ ] `flutter pub outdated` + 네이티브 관련 패키지 확인
- [ ] `README.md` 요구사항 표 업데이트
- [ ] 이 문서(`docs/VERSION_MANAGEMENT.md`)의 권장 버전 표 업데이트

---

## 4. “어디에 버전을 적나” 요약

```
앱 스토어 버전     → pubspec.yaml (version)
Dart 언어 범위     → pubspec.yaml (environment.sdk)
패키지 선언        → pubspec.yaml (dependencies)
패키지 실제 고정   → pubspec.lock
Flutter 기준 리비전 → .metadata
iOS 최소 OS        → ios/Podfile (+ project.pbxproj)
iOS 권한/UIScene   → ios/Runner/Info.plist, SceneDelegate.swift
Android 빌드 툴체인 → android/settings.gradle.kts, gradle-wrapper.properties
팀 공유 요구사항   → README.md + 이 문서
```

---

## 5. 하지 말 것

- `ios/Pods/`, Flutter `Generated.*` / `ephemeral/` 커밋하기
- `GoogleService-Info.plist`, `google-services.json`, `firebase_options.dart` 깃에 올리기
- `pubspec.lock` 을 무시하고 각자 `pub upgrade`만 하기
- Xcode만 올리고 Flutter는 예전 버전(예: 3.24)에 두기
- `android/local.properties` 커밋하기

---

## 6. 관련 문서 / 스크립트

- 로컬 셋업·Xcode 27 요약: [README.md](../README.md)
- iOS 시뮬레이터 실행: [IOS_SIMULATOR.md](./IOS_SIMULATOR.md)
- iOS 재생성: `scripts/setup_ios.sh`
- iOS 템플릿: `tool/ios_xcode27/`

---

## 7. 변경 이력 (이 문서)

| 날짜 | 내용 |
| --- | --- |
| 2026-10-10 | 초안 작성. Xcode 27 / Flutter 3.47+ / iOS 15.0 기준 정리 |
| 2026-10-10 | `ios/` 소스 추적 전환. Pods·Generated·Firebase plist 만 ignore |
