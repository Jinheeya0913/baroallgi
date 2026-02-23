import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';

class ArticleMainPage extends HookConsumerWidget {
  static String get routeName => 'article_main';

  const ArticleMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(child: Text('test'),);
  }
}
