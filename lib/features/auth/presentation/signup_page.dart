import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:baroallgi/core/ui/widgets/base_elevated_button.dart';
import 'package:baroallgi/core/ui/widgets/base_snack_bar.dart';
import 'package:baroallgi/core/ui/widgets/base_text_field.dart';
import 'package:baroallgi/features/auth/auth_validators.dart';
import 'package:baroallgi/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SingUpPage extends HookConsumerWidget {
  const SingUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    final nicknameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final passwordError = useState<String?>(null);
    final isSubmitting = useState(false);

    return DefaultLayout(
      title: _title(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BaseTextField(
                    controller: nicknameController,
                    focusNode: nicknameFocusNode,
                    labelText: '닉네임을 입력하시오',
                    inputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      emailFocusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: AppSizes.s20),
                  BaseTextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    labelText: '이메일을 입력하시오',
                    inputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      passwordFocusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: AppSizes.s20),
                  BaseTextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    labelText: '비밀번호를 입력하시오',
                    hideText: true,
                    errorText: passwordError.value,
                    inputAction: TextInputAction.done,
                    onChanged: (value) {
                      passwordError.value = validatePassword(value);
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.s20),
          BaseElevatedButton(
            text: '회원가입하기',
            isLoading: isSubmitting.value,
            onPressed: () {
              _signUp(
                context: context,
                ref: ref,
                nickname: nicknameController.text,
                email: emailController.text,
                password: passwordController.text,
                passwordError: passwordError,
                isSubmitting: isSubmitting,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return const Text(
      '회원가입',
      style: TextStyle(fontSize: AppSizes.s40, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _signUp({
    required BuildContext context,
    required WidgetRef ref,
    required String nickname,
    required String email,
    required String password,
    required ValueNotifier<String?> passwordError,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    if (isSubmitting.value) return;

    final nicknameMsg = validateNickname(nickname);
    if (nicknameMsg != null) {
      _showMessage(context, nicknameMsg);
      return;
    }

    final emailMsg = validateEmail(email);
    if (emailMsg != null) {
      _showMessage(context, emailMsg);
      return;
    }

    final passwordMsg = validatePassword(password);
    passwordError.value = passwordMsg;
    if (passwordMsg != null) {
      _showMessage(context, passwordMsg);
      return;
    }

    isSubmitting.value = true;
    try {
      final result = await ref.read(authNotifierProvider.notifier).signUp(
            email: email.trim(),
            password: password,
            nickname: nickname.trim(),
          );

      if (!context.mounted) return;

      if (result.resultCode == '00') {
        _showMessage(
          context,
          result.resultMsg ?? '인증 메일을 보냈습니다. 메일 확인 후 로그인해주세요.',
        );
        context.pop();
      } else {
        _showMessage(
          context,
          result.resultMsg ?? '회원가입에 실패했습니다.',
        );
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      BaseSnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
  }
}
