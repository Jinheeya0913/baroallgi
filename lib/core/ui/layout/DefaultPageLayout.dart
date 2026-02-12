import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

// import 'package:goodedunote/common/component/user_drawer.dart';

import 'package:baroallgi/core/ui/theme/theme_color.dart';
import 'package:baroallgi/core/const/const_size.dart';

class DefaultLayout extends HookConsumerWidget {
  final Widget child;
  final Widget? title;
  final Widget? bottomNavigationBar;
  final bool useDrawer;
  final bool useAppBar;
  final bool useBackBtn;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;

  const DefaultLayout({
    super.key,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.useDrawer = false,
    this.useBackBtn = false,
    this.useAppBar = true,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFab =
        floatingActionButton != null &&
            floatingActionButtonLocation != null;

    // Hook 예시: 키보드 dismiss용 focus
    // final focusScope = useFocusScope();

    return Scaffold(
      //resizeToAvoidBottomInset : false,
      drawer: null, // 드라우러 사용하기 전까지는 null 처리
      // const UserDrawer() : null,
      appBar: useAppBar ? _buildAppBar(context) : null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // 빈 공간 터치도 인식
        onTap: () => FocusScope.of(context).unfocus(), // 바깥 터치 시 키보드 dismiss
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(CNST_SIZE_16),
            child: child,
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
        child: SafeArea(
          child: bottomNavigationBar!,
        ),
      ),
      floatingActionButton: hasFab ? floatingActionButton : null,
      floatingActionButtonLocation:
      hasFab ? floatingActionButtonLocation : null,
      backgroundColor: Colors.white,
    );
  }


  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: title,
      actions: [
        // IconButton(
        //   onPressed: () {},
        //   icon: const Badge(
        //     label: Text('2'),
        //     backgroundColor: THEME_COLOR_MAIN,
        //     child: Icon(Icons.notifications),
        //   ),
        // ),
      ],
      leading: useBackBtn
          ? IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.pop(),
      )
          : useDrawer
          ? Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      )
          : null,
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 100,
    );
  }
}
