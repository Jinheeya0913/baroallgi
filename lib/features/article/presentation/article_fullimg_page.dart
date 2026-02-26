import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';

class ArticleFullImgPage extends HookConsumerWidget {
  static String get routeName => 'article_full';
  const ArticleFullImgPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(child: Text('test'),);
  }
}
