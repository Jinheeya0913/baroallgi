import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/provider/storage_provider.dart';
import 'package:baroallgi/core/ui/widgets/AppLogoImg.dart';
import 'package:baroallgi/core/ui/widgets/BaseSnackBar.dart';
import 'package:baroallgi/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:baroallgi/core/ui/widgets/BaseTextField.dart';

class LoginPage extends HookConsumerWidget {
  static String get routeName => 'login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authNotifierProvider);

    final autoLogin = useState(false);

    // 스크롤 이벤트
    final scrollController = useScrollController();
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom - 100;

    // 로그인 정보
    // 컨트롤러에 담아서 수행
    final userEmailController = useTextEditingController();
    final userPwController = useTextEditingController();

    // keyboardInset과 passwordFocusNode 의 포커스가 바뀔 때만 수행
    useEffect(() {
      if (keyboardInset > 0 && passwordFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!scrollController.hasClients) return;

          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        });
      }
      return null;
    }, [keyboardInset, passwordFocusNode.hasFocus]);

    return DefaultLayout(
      useAppBar: false,
      child: Column(
        children: [
          _title(),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(bottom: CNST_SIZE_16),
              child: Column(
                children: [
                  Column(
                    children: [
                      CheckboxListTile(
                        value: autoLogin.value,
                        onChanged: (val) {
                          autoLogin.value = val ?? false;
                        },

                        title: const Text('자동 로그인'),
                        controlAffinity: ListTileControlAffinity.leading,
                        // 체크박스 왼쪽
                        contentPadding: EdgeInsets.zero,
                      ),

                      BaseTextField(
                        controller: userEmailController,
                        focusNode: emailFocusNode,
                        onFieldSubmitted: (_) {
                          // 비밀번호로 포커스 이동
                          passwordFocusNode.requestFocus();

                          // 키보드 올라올 시간 확보
                          Future.delayed(const Duration(milliseconds: 150), () {
                            /// hasclients : 화면이 완전히 렌더링되어 컨트롤러가
                            /// scrollview 위젯에 부톡 난 다음에 해당 기능이 작동될 수 있도록 안전장치
                            if (!scrollController.hasClients) return;

                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 250),

                              /// 애니메이션 효과 빠르게 가다가 느리게
                              curve: Curves.easeOut,
                            );
                          });
                        },
                        inputAction: TextInputAction.next,
                        hintText: '이메일을 입력하세요',
                        hintStyle: TextStyle(
                          fontSize: CNST_SIZE_16,
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(height: CNST_SIZE_20),
                      BaseTextField(
                        controller: userPwController,
                        onFieldSubmitted: (_) {
                          _login(
                            ref: ref,
                            context: context,
                            userEmail: userEmailController.text,
                            userPw: userPwController.text,
                          );
                        },
                        focusNode: passwordFocusNode,
                        hintText: '비밀번호를 입력하세요',
                        hintStyle: TextStyle(
                          fontSize: CNST_SIZE_16,
                          color: Colors.black45,
                        ),
                        hideText: true,
                      ),
                      SizedBox(height: CNST_SIZE_20),
                    ],
                  ),
                  // 버튼 컬럼
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _login(
                                  ref: ref,
                                  context: context,
                                  userEmail: userEmailController.text,
                                  userPw: userPwController.text,
                                );
                              },
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                  fontSize: CNST_SIZE_20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                              ),
                              child: Text(
                                '카카오 로그인',
                                style: TextStyle(
                                  fontSize: CNST_SIZE_20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _signUp(
                                  ref: ref,
                                  context: context,
                                  userEmail: userEmailController.text,
                                  pw: userPwController.text,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                              ),
                              child: Text(
                                '회원가입 테스트',
                                style: TextStyle(
                                  fontSize: CNST_SIZE_20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return AppLogoImg(width: 200,);
  }

  void _login({
    required WidgetRef ref,
    required BuildContext context,
    required String userEmail,
    required String userPw,
  }) async {
    if (userEmail.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이메일을 입력해주시길 바랍니다.', textAlign: TextAlign.center,)));
      return;
    } else if (userPw.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('비밀번호를 입력해주시길 바랍니다.', textAlign: TextAlign.center,)));
      return;
    }

    await ref.read(authNotifierProvider.notifier).signIn(email: userEmail, password: userPw);

    final result = ref.read(authNotifierProvider);

    if(result != null){
      if(result.resultCode != '00') {
        ScaffoldMessenger.of(context).showSnackBar(
            BaseSnackBar(content: Text('${result.resultMsg}')));
      } else {
        ref.read(storageProvider).write(key: 'useAutoLogin', value: 'true');
      }
    } else {
      // 로그인 실패
      ScaffoldMessenger.of(context).showSnackBar(BaseSnackBar(content: Text('로그인 실패')));
    }

  }

  void _signUp({
    required WidgetRef ref,
    required BuildContext context,
    required String userEmail,
    required String pw,
  }) async {
    await ref
        .read(authNotifierProvider.notifier)
        .signUp(email: userEmail, password: pw);

    final result = ref.read(authNotifierProvider);

    if (result != null && result.resultCode == '00') {
      print('rlog :: 회원가입 성공');
    } else {
      print('rlog :: 회원가입 실패 -> ${result?.resultMsg}');
    }


  }
}
