import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/theme/theme_color.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BaseTextField extends HookWidget {
  // TEXT 입력값
  final String? hintText; // 힌트 텍스트
  final String? errorText; // 에러 텍스트
  final FormFieldValidator? validator;

  final bool hideText; // 비밀번호 입력시 **** 표시
  final bool autoFocus;
  final double circleBorder; // 테두리 둥글게

  // 옵션 입력
  final bool digitOnly; // 숫자만 입력
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  final double? contentPadding;
  final bool filled;
  final Color borderColor;
  final bool useBorder;
  final int? maxLines;
  final double borderWidth;
  final String? labelText;

  final TextInputAction? inputAction; // 키보드 확인 버튼 액션
  final ValueChanged<String>? onFieldSubmitted; // 키보드 확인 버튼
  final TextEditingController? controller;

  // 스타일
  final TextStyle? labelTextStyle;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? cursorColor;

  // 이벤트
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;

  final bool scrollToBottom;

  const BaseTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.errorText, // 오류
    this.validator,
    this.hideText = false,
    this.autoFocus = false,
    this.circleBorder = CNST_SIZE_NORMAL,
    this.digitOnly = false,
    this.maxLength,
    this.contentPadding,
    this.filled = true,
    this.borderColor = THEME_COLOR_WHITE,
    this.useBorder = true,
    this.maxLines = 1,
    this.borderWidth = 1,
    this.cursorColor = THEME_COLOR_MAIN,
    this.labelText,
    this.labelTextStyle,
    this.style,
    this.inputAction,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.hintStyle,
    this.onTap,
    this.scrollToBottom = false,
    // 포커스 노드
  });

  @override
  Widget build(BuildContext context) {
    final internalFocusNode = focusNode ?? useFocusNode();

    // useEffect(() {
    //   void listener() {
    //     if (internalFocusNode.hasFocus) {
    //       final scrollable = Scrollable.of(internalFocusNode.context!);
    //       if (internalFocusNode.context != null) {
    //         if (scrollToBottom) {
    //           // 스크롤 최하단으로
    //           Future.delayed(const Duration(milliseconds: 500), () {
    //             print('rlog :: 최하단 이동1');
    //             scrollable.position.animateTo(
    //               scrollable.position.maxScrollExtent,
    //               duration: const Duration(milliseconds: 500),
    //               curve: Curves.easeOut,
    //             );
    //           });
    //
    //         } else {
    //           Future.delayed(const Duration(milliseconds: 300), () {
    //             print('rlog :: 최하단 이동2');
    //             Scrollable.ensureVisible(
    //               internalFocusNode.context!,
    //               duration: const Duration(milliseconds: 300),
    //               curve: Curves.easeInOut,
    //               alignment: 2.0,
    //             );
    //           });
    //         }
    //       }
    //     }
    //   }
    //
    //   internalFocusNode.addListener(listener);
    //   return () => internalFocusNode.removeListener(listener);
    // }, [internalFocusNode,scrollToBottom]);

    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(circleBorder)),
    );

    final unVisibleBorder = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );

    return TextFormField(
      controller: controller,
      inputFormatters: [if (digitOnly) FilteringTextInputFormatter.digitsOnly],
      // 입력 양식
      maxLength: maxLength == null ? null : maxLength,
      // 입력길이 제한 null => 여러 줄 입력 가능
      maxLines: hideText == true ? 1 : maxLines,
      cursorColor: cursorColor,
      // 암호 텍스트
      obscureText: hideText,
      obscuringCharacter: '*',
      // 이벤트
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      textInputAction: inputAction ?? TextInputAction.done,
      onTap: onTap,
      // 포커스
      autofocus: autoFocus,
      // 자동 포커스
      focusNode: internalFocusNode,
      // 수동 포커스

      // 꾸미기
      style: style,
      decoration: InputDecoration(
        counter: const Offstage(),
        contentPadding: contentPadding != null
            ? EdgeInsets.all(contentPadding!)
            : const EdgeInsets.all(CNST_SIZE_20),

        // hint
        hintText: hintText,
        hintStyle:
            hintStyle ?? TextStyle(color: Colors.grey, fontSize: CNST_SIZE_14),
        // error
        errorText: errorText,

        fillColor: THEME_COLOR_WHITE,
        filled: filled,

        // 배경생 유무
        border: useBorder ? baseBorder : null,
        enabledBorder: useBorder ? baseBorder : unVisibleBorder,

        // 선택된 상태에서의 볼더
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(color: cursorColor),
        ),
        labelText: labelText,
        labelStyle: labelTextStyle,
      ),
    );
  }
}
