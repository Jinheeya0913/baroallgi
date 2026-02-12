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
    routes: [
      // 하위 경로들...
    ],
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
