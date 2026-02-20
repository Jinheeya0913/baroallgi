import 'package:baroallgi/core/photo/image_picker_page.dart';
import 'package:baroallgi/core/provider/auth_status_provider.dart';
import 'package:baroallgi/features/auth/presentation/login_page.dart';
import 'package:baroallgi/features/example/test_route_page.dart';
import 'package:baroallgi/features/main/home_page.dart';
import 'package:baroallgi/features/report/presentation/card_edit_page.dart';
import 'package:baroallgi/features/report/presentation/report_page.dart';
import 'package:baroallgi/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'routes.dart'; // 위에서 만든 routes.dart를 가져옴

final routerProvider = Provider<GoRouter>((ref) {
  final authStatusProvider = ref.watch(authStatusNotifier);

  return GoRouter(
    initialLocation: '/route_test',
    refreshListenable: authStatusProvider,
    // 테스트일 때는 redirect 주석
    // redirect: authStatusProvider.redirectLogic, // authStatus가 바뀌거나 페이지 이동할 때마다 수행
    routes: _routes, // routes.dart에 정의된 리스트 사용
  );
});