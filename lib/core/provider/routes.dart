part of 'app_router.dart';

List<GoRoute> _routes = [
  GoRoute(
    path: '/splash',
    name: 'splash',
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: '/main',
    name: 'main',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/report',
    name: 'report',
    builder: (context, state) => const ReportPage(),
    routes: [
      GoRoute(
        path: 'cardEdit',
        name: 'cardEdit',
        builder: (context, state) => const CardEditPage(),
      ),
    ],
  ),
  GoRoute(
    path: '/image_picker',
    name: 'image_picker',
    builder: (context, state) => const ImagePickerPage(),
  ),
  GoRoute(
    path: '/route_test',
    name: 'route_test',
    builder: (context, state) => const RouteTestPage(),
  ),
  GoRoute(
    path: '/article_main',
    name: 'article_main',
    builder: (context, state) => const ArticleMainPage(),
    routes: [
      GoRoute(
        path: 'article_detail',
        name: 'article_detail',
        builder: (context, state) => const ArticleDetailPage(),
      ),
    ]
  ),

  //
];

// 기존에 쓰시던 애니메이션 함수도 여기 두면 깔끔합니다.
CustomTransitionPage buildPageWithTransition({
  required Widget child,
  required String state,
}) {
  return CustomTransitionPage(
    key: ValueKey(state),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
