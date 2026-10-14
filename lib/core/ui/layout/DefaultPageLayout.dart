import 'package:baroallgi/core/const/const_color.dart';
import 'package:baroallgi/core/ui/widgets/base_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:baroallgi/core/const/const_size.dart';

class DefaultLayout extends HookConsumerWidget {
  final Widget child;
  final Widget? title;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomNavigationBar;
  final bool useDrawer;
  final bool useAppBar;
  final bool useBackBtn;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final bool resiseWithKeyboard;
  final List<Widget>? actions;

  const DefaultLayout({
    super.key,
    required this.child,
    this.title,
    this.padding,
    this.bottomNavigationBar,
    this.useDrawer = false,
    this.useBackBtn = false,
    this.useAppBar = true,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.floatingActionButton,
    this.resiseWithKeyboard = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFab = floatingActionButton != null;
    final fromRouteTest = _openedFromRouteTest(context);

    return Scaffold(
      resizeToAvoidBottomInset: resiseWithKeyboard,
      appBar: useAppBar ? _buildAppBar(context, fromRouteTest) : null,
      // deferToChild: 자식 버튼/ListTile 터치를 가로채지 않음
      // (translucent + onTap 은 iOS 시뮬레이터에서 탭 경쟁을 일으킬 수 있음)
      body: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: padding ?? EdgeInsets.all(AppSizes.normal),
                child: child,
              ),
              if (fromRouteTest && !useAppBar)
                const Positioned(
                  top: AppSizes.s14,
                  right: AppSizes.s14,
                  child: _RouteTestShortcutButton(filled: true),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar == null
          ? null
          : AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SafeArea(child: bottomNavigationBar!),
            ),
      floatingActionButton: hasFab ? floatingActionButton! : null,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset : false,
      drawer: useDrawer == true ? renderDrawer() : null,
      // const UserDrawer() : null,
    );
  }

  // AppBar _buildAppBar(BuildContext context) {
  //   return AppBar(
  //     title: title,
  //     actions: actions,
  //     leading: useBackBtn
  //         ? IconButton(
  //             icon: const Icon(Icons.arrow_back_rounded),
  //             onPressed: () => context.pop(),
  //           )
  //         : useDrawer
  //         ? Builder(
  //             builder: (context) => IconButton(
  //               icon: const Icon(Icons.menu),
  //               onPressed: () => Scaffold.of(context).openDrawer(),
  //             ),
  //           )
  //         : null,
  //     backgroundColor: Colors.white,
  //     surfaceTintColor: Colors.white,
  //     centerTitle: true,
  //     elevation: 0,
  //     toolbarHeight: 60,
  //   );
  // }
  AppBar _buildAppBar(BuildContext context, bool fromRouteTest) {
    return AppBar(
      title: title, // 로고 이미지
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      actions: [
        ...?actions,
        if (fromRouteTest) const _RouteTestShortcutButton(),
      ],
      elevation: 0,
      toolbarHeight: 60,
      leading: useBackBtn
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => context.pop(),
        color: AppColors.primaryNavy,
      )
          : useDrawer
          ? Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, size: 28),
          onPressed: () => Scaffold.of(context).openDrawer(),
          color: AppColors.primaryNavy,
        ),
      )
          : null,
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(1.0),
      //   child: Container(
      //     color: AppColors.divider,
      //     height: 1.0,
      //   ),
      // ),
    );
  }

  BaseDrawer renderDrawer() {
    return BaseDrawer();
  }
}

/// 테스트 라우터에서 push로 쌓인 화면인지.
/// go_router는 imperative push 동안 base uri를 유지한다.
bool _openedFromRouteTest(BuildContext context) {
  final basePath =
      GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
  if (basePath != '/route_test') return false;
  return GoRouterState.of(context).matchedLocation != '/route_test';
}

class _RouteTestShortcutButton extends StatelessWidget {
  final bool filled;

  const _RouteTestShortcutButton({this.filled = false});

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      tooltip: '라우터로 바로가기',
      onPressed: () => context.go('/route_test'),
      color: AppColors.primaryNavy,
      icon: const Icon(Icons.alt_route_rounded),
    );

    if (!filled) return button;

    return Material(
      color: AppColors.surface,
      elevation: 2,
      shape: const CircleBorder(),
      child: button,
    );
  }
}
