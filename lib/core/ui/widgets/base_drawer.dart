import 'package:baroallgi/core/const/const_color.dart';
import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/features/auth/models/auth_model.dart';
import 'package:baroallgi/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BaseDrawer extends HookConsumerWidget {
  const BaseDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final nickname = auth?.userAddInfo?.nickname.trim();
    final nicknameLabel =
        (nickname != null && nickname.isNotEmpty) ? nickname : '닉네임 없음';
    final isMain = GoRouterState.of(context).uri.path == '/main';

    return Drawer(
      width: MediaQuery.of(context).size.width / 2,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              color: AppColors.accentSky,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + AppSizes.normal,
                left: AppSizes.normal,
                right: AppSizes.normal,
                bottom: AppSizes.normal,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  nicknameLabel,
                  style: const TextStyle(
                    fontSize: AppSizes.s20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          if (!isMain)
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈으로'),
              onTap: () {
                Navigator.pop(context);
                context.go('/main');
              },
            ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('메시지'),
            onTap: () {},
          ),
          if (auth != null)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('프로필 수정'),
              onTap: () {
                Navigator.pop(context);
                context.push('/profile_edit');
              },
            ),
          if (auth != null)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () async {
                _logout(ref, auth);
              },
            ),
        ],
      ),
    );
  }

  void _logout(WidgetRef ref, AuthModel auth) {
    ref.read(authNotifierProvider.notifier).logout(auth);
  }
}
