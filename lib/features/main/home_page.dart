import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  static String get routeName => 'main';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(child: Text('test'),);
  }
}
