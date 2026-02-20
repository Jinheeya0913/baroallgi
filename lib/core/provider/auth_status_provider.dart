import 'dart:async';

import 'package:baroallgi/features/auth/models/auth_model.dart';

import 'package:baroallgi/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/src/state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStatusNotifier = ChangeNotifierProvider<AuthStatusProvider>((ref) {
  return AuthStatusProvider(ref: ref);
});

class AuthStatusProvider extends ChangeNotifier {
  final Ref ref;

  AuthStatusProvider({required this.ref}) {
    // 유저 정보가 바뀌면 라우터에 알림을 줍니다.
    ref.listen<AuthModel?>(authNotifierProvider, (prev, next) {
      if (prev != next) {
        notifyListeners();
      }
    });
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    AuthModel? auth = ref.read(authNotifierProvider);
    final location = state.fullPath;

    print('rlog :: now full path : $location');

    final isSplash = state.fullPath == '/splash';
    final isLogin = state.fullPath == '/login';

    // 테스트용
    // auth = null;

    if (auth == null && isSplash) {
      return '/login';
    }

    if(auth== null) {
      print('rlog :: auth 정보 없음');
      return (isLogin) ? null : '/login';
    }else {
      print('rlog :: ${auth.userModel!.email}');
      if(isLogin || isSplash) {
        return '/main';
      }
    }

    return null;
  }
}
