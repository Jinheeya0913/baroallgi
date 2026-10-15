import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 프로필 수정 화면. UI·저장은 아직 구현하지 않는다.
class ProfileEditPage extends HookConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: const Text(
        '프로필 수정',
        style: TextStyle(fontSize: AppSizes.s20, fontWeight: FontWeight.bold),
      ),
      child: const Center(
        child: Text('준비 중입니다.'),
      ),
    );
  }
}
