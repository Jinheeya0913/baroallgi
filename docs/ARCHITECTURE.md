# 아키텍처

baroallgi(바로알기)는 Flutter 앱이다. 잘못된 정보를 바로잡는 카드뉴스·제보 앱이고, 상태 관리는 Riverpod, 화면 이동은 GoRouter, 백엔드는 Firebase(Auth, Firestore, Storage)다.

새 화면·기능은 이 문서의 폴더와 레이어를 따른다. 기존 파일의 이름이나 위치를 맞추려고 옮기지 않는다.

## 디렉터리

```
lib/
  main.dart                 # Firebase 초기화, ProviderScope, MaterialApp.router
  splash_page.dart          # 스플래시 (피처 밖)
  firebase_options.dart     # FlutterFire 생성물. 수동 수정하지 않음
  core/                     # 피처에 속하지 않는 공용 코드
    const/                  # 색, 크기, 결과 코드, 앱 메타
    enum/
    network/models/         # BaseResponse, PaginatedResponse
    photo/                  # ImagePickerPage
    provider/               # 라우터, Firebase, 스토리지, 권한, 로그인 리다이렉트
    ui/
      layout/DefaultPageLayout.dart   # DefaultLayout (파일명만 PascalCase)
      theme/theme_color.dart
      widgets/              # base_*.dart, app_logo_img, base_drawer
  features/
    auth/                   # 로그인·회원가입
    article/                # 카드뉴스 (레이어가 가장 완전함)
    report/                 # 제보 작성 (presentation만)
    main/home_page.dart     # 홈
    example/test_route_page.dart  # 개발용 라우트 목록. 초기 진입 화면
```

`assets/fonts/`, `assets/images/`. 앱 폰트는 `BMHANNA`.

## 피처 레이어

도메인 폴더는 없다. 저장소 인터페이스가 도메인 역할을 한다. 기준 피처는 `article`이다.

```
features/<feature>/
  models/                         # json_serializable 모델. *.g.dart는 생성물
  data/datasources/               # Firebase 등 외부 I/O만
  data/repositories/              # <name>_repository.dart (abstract)
                                  # <name>_repository_impl.dart
  provider/                       # Riverpod. datasource → repository → notifier
  presentation/                   # 페이지, 그 화면 전용 위젯
```

호출 방향은 `presentation → provider → repository → datasource`다. 페이지와 notifier에서 Firestore·FirebaseAuth를 직접 호출하지 않는다.

`auth`만 provider가 `presentation/provider/auth_provider.dart`에 있다. 새 기능은 `article`처럼 `provider/`를 presentation 밖에 둔다.

화면만 있는 피처(`report`)는 `presentation/`만 둬도 된다. 데이터 레이어는 외부 I/O가 생길 때 추가한다.

## 이름

새 파일과 타입은 아래를 따른다. 이미 있는 이름의 불일치는 맞추려고 고치지 않는다.

### 모듈

- 피처 폴더는 `lib/features/<feature>/`. 사용자에게 보이는 기능 하나의 명사다. snake_case이고 짧게 쓴다. 예: `auth`, `article`, `report`, `chat`.
- 두 피처 이상이 쓰는 코드만 `lib/core/<area>/`에 둔다. 영역 이름도 역할 명사다. 예: `const`, `provider`, `ui`.
- 레이어 폴더 이름은 고정한다. `models`, `data/datasources`, `data/repositories`, `provider`, `presentation`.
- `main`은 홈 셸, `example`은 개발용 진입이다. 제품 기능 폴더로 쓰지 않는다.
- 한 화면에서만 쓰는 위젯은 그 페이지 파일의 private 클래스다. 예: `_CategoryChip`. 같은 피처의 여러 화면이 쓰면 `presentation/widgets/`. 앱 전체에서 쓰면 `core/ui/widgets/`.

### 파일

Dart 파일은 snake_case다. 파일명은 그 파일의 대표 public 타입을 snake_case로 옮긴 것이다. 그 타입과 항상 같이 쓰는 작은 모델은 같은 파일에 둘 수 있다.

| 종류 | 파일 | 타입 |
| --- | --- | --- |
| 페이지 | `article_list_page.dart` | `ArticleListPage` |
| 모델 | `article_model.dart` | `ArticleModel` |
| 생성물 | `article_model.g.dart` | 수정하지 않음 |
| 저장소 | `article_repository.dart` | `ArticleRepository` (abstract) |
| 저장소 구현 | `article_repository_impl.dart` | `ArticleRepositoryImpl` |
| 데이터소스 | `auth_remote_datasource.dart` | `AuthRemoteDataSource` |
| 상태 | `article_provider.dart` | provider 변수와 notifier 클래스를 한 파일에 |
| 공용 위젯 | `base_text_field.dart` | `BaseTextField` |
| 상수·메타 | `const_size.dart`, `app_metadata.dart` | 주제별 한 파일 |

- 페이지 접미사는 `_page.dart` / `Page`. 모델 접미사는 `_model.dart` / `Model`.
- 모델의 `part`는 파일명과 같다. `part 'article_model.g.dart';`
- enum 파일은 `<name>.dart` 또는 `<name>_enum.dart`. 한 피처만 쓰는 enum은 그 피처에 둔다.

### 식별자

- 타입(class, enum, typedef)은 PascalCase. 변수, 함수, provider는 lowerCamelCase.
- Riverpod 전역 변수는 `<역할>Provider`로 끝낸다. 예: `articleRepositoryProvider`, `firestoreProvider`. notifier용 provider도 같다.
- private 멤버와 화면 전용 위젯은 `_`로 시작한다.
- 라우트 `path`와 `name`은 snake_case다. `name`은 path에서 `/`를 뺀 값이다. 중첩 자식 path에는 선행 `/`를 붙이지 않는다. 예: 부모 `/article_main`, 자식 `article_list`, name `article_list`.
- 새 enum 값은 lowerCamelCase다.
- 새 색·크기는 전역 접두 상수 대신 타입 안의 lowerCamelCase로 둔다. 예: `AppColors.primaryNavy`.

### 기존 예외

아래는 규칙과 어긋나 있지만 이름을 바꾸지 않는다.

- `core/ui/layout/DefaultPageLayout.dart` — 클래스 `DefaultLayout`. 이 파일만 PascalCase다.
- `features/example/test_route_page.dart` — 클래스 `RouteTestPage`.
- `features/auth/presentation/signup_page.dart` — 클래스 `SingUpPage`.
- `features/article/data/datasources/article_remote_datasource.dart` — 클래스 `ArticleDatasource`.
- `features/article/provider/article_provider.dart` — 변수 이름이 `articleNotifier`다.
- `features/auth/presentation/provider/` — provider가 presentation 안에 있다. 새 기능은 피처 루트의 `provider/`에 둔다.
- `features/main/home_page.dart`, `lib/splash_page.dart` — `presentation/` 밖에 있다.
- `core/enum/article_type_enum.dart` — article 전용 enum이 core에 있고, 값은 `FULLIMG`처럼 대문자다.
- `const_size.dart`, `theme_color.dart` — `CNST_`, `CONST_`, `THEME_COLOR_` 전역 상수. 새 값은 여기에 추가하지 않고 `AppColors`와 크기 타입을 쓴다.

## 상태와 모델

- 앱 루트는 `ProviderScope`. 위젯은 `HookConsumerWidget` 또는 `ConsumerWidget`.
- 새로 만드는 상태는 `Notifier` 또는 `AsyncNotifier`다. 처음 값이 동기고 사용자 동작으로 바뀌면 `Notifier`, 처음 로드가 비동기면 `AsyncNotifier`다.
- 파일은 `features/<feature>/provider/<name>_provider.dart`다. 클래스는 `<Name>Notifier`, 변수는 `<name>Provider`다. 화면 수명에만 필요하면 `NotifierProvider.autoDispose` / `AsyncNotifierProvider.autoDispose`를 쓴다.
- 저장소는 생성자로 받지 않는다. `build()`에서 `ref.watch`로 읽고, 화면은 `ref.watch(<name>Provider)`로 구독한다. 상태는 통째로 바꾼다.
- `@riverpod` 코드젠은 쓰지 않는다. provider는 손으로 선언한다.
- 이미 있는 `ChangeNotifier`와 `StateNotifier`는 그 파일을 기능 수정할 때까지 유지한다. `articleNotifier`, `authNotifierProvider`, `authStatusNotifier`, `PermissionProvider`, `SelectImageProvider`.
- 공용 Firebase 인스턴스는 `lib/core/provider/firebase_provider.dart`의 `firebaseAuthProvider`, `firestoreProvider`를 재사용한다.

```dart
class ChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => [];

  void add(ChatMessage message) {
    state = [...state, message];
  }
}

final chatProvider =
    NotifierProvider<ChatNotifier, List<ChatMessage>>(ChatNotifier.new);
```
- API 형태 응답은 `BaseResponse` / `PaginatedResponse` (`core/network/models`).
- 모델은 `@JsonSerializable()`과 `part '*.g.dart'`. `*.g.dart`는 손으로 고치지 않고 `dart run build_runner build --delete-conflicting-outputs`로 갱신한다.
- 디버그 로그는 `print('rlog :: ...')` 또는 `debugPrint('rlog :: ...')`.

## 라우팅

`routerProvider`(`core/provider/app_router.dart`)가 `GoRouter`를 만든다. 경로 목록은 `part` 파일 `core/provider/routes.dart`의 `_routes`다.

- 경로를 추가하면 `routes.dart`에 `GoRoute`를 넣고, `app_router.dart`에 페이지만 import한다.
- 이동은 `context.push(path)`. 라우트 `name`은 path에서 `/`를 뺀 스네이크 케이스다. 예: `/article_main` → `article_main`.
- 중첩 경로는 부모 `routes` 안에 둔다. 예: `/article_main/article_list`.
- 추가 인자는 `state.extra`의 전용 클래스다. 예: `ImagePickerArgs`. 화면이 모델 하나면 그 모델을 그대로 넘긴다.
- 현재 `initialLocation`은 `/route_test`다. `redirect`(로그인 게이트)는 주석 처리되어 있다. 테스트 중에는 이 상태를 유지한다.
- 개발 중 화면은 `RouteTestPage`에 `_buildPushCard` 한 줄을 추가해 진입한다.

## UI

- 일반 화면은 `DefaultLayout`(`core/ui/layout/DefaultPageLayout.dart`)으로 감싼다. AppBar, 패딩, 키보드 내림, drawer를 여기서 처리한다.
- 간격·글자 크기는 `core/const/const_size.dart` (`CNST_SIZE_NORMAL`, `CNST_FONT_SIZE_BIG` 등).
- 색은 `core/ui/theme/theme_color.dart`의 `AppColors` 또는 `core/const/const_color.dart`. 홈의 일부 카드만 로컬 `Color(0xFF...)`를 쓴다.
- 재사용 입력·버튼·스낵바는 `core/ui/widgets/base_*.dart`.
- 로케일은 `ko_KR` 고정.

## 챗봇 (예정, 아직 없음)

LLM은 연결하지 않는다. UI만 먼저 만들고, 진입은 `RouteTestPage`에 붙인다.

- 코드 위치: `lib/features/chat/presentation/`. 메시지 목록 상태는 `lib/features/chat/provider/`의 `Notifier`로 만든다. `data/`와 `firebase_ai`는 AI 연동 단계에서 추가한다.
- 라우트: `routes.dart`에 등록하고 `test_route_page.dart`에 카드로 연결한다.
- 홈 진입은 그 다음이다. `HomePage._buildReportCard`의 `Icons.campaign_rounded`(약 312–314행)를 챗봇 아이콘으로 바꾸고, 탭 시 챗 화면으로 보낸다. UI 단계에서는 이 아이콘과 홈 탭 동작을 바꾸지 않는다.
