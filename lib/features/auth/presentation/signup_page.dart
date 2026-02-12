import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:baroallgi/core/ui/widgets/BaseTextField.dart';

class SingUpPage extends HookConsumerWidget {
  const SingUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusNode _node1 = FocusNode();
    final FocusNode _node2 = FocusNode();

    return DefaultLayout(
      title: _title(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BaseTextField(
                    onChanged: (val) {},
                    labelText: '이름을 입력하시오',
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_node2);
                    },
                  ),
                  SizedBox(height: CNST_SIZE_20),
                  BaseTextField(
                    focusNode: _node2,
                    onChanged: (val) {},
                    labelText: '이메일을 입력하시오',
                    inputAction: TextInputAction.done,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _title() {
    return const Text(
      '회원가입',
      style: TextStyle(fontSize: CNST_SIZE_40, fontWeight: FontWeight.bold),
    );
  }
}
