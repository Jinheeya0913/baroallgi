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
  ),
  GoRoute(
    path: '/image_picker',
    name: 'image_picker',
    builder: (context, state) => const ImagePickerPage(),
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
