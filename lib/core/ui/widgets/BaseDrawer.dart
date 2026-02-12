import 'package:baroallgi/core/ui/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class BaseDrawer extends HookConsumerWidget {
  const BaseDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 2,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              color: THEME_COLOR_MAIN,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // const UserProfileCircle(),
                  // Text(model != null ? model.userAlias : ''),
                  // Text(model != null ? model.userEmail : ''),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('홈으로'),
            onTap: () {
              // Navigator.pop(context);
              // context.goNamed(SplashScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('메시지'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('로그아웃'),
            onTap: () {
              // final result = state.logout();
            },
          ),
        ],
      ),
    );
  }
}
