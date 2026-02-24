import 'package:baroallgi/core/const/const_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BaseFloatingButton extends HookConsumerWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon; // 아이콘 추가로 직관성 향상
  final TextStyle? labelStyle;
  final List<Color>? gradientColors; // 배경색 대신 그라데이션 적용

  const BaseFloatingButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
    this.labelStyle,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 기본 그라데이션: Navy -> Blue (신뢰감)
    final colors = gradientColors ?? [AppColors.primaryNavy, AppColors.primaryBlue];

    return Container(
      // 화면 너비의 90% 정도를 차지하도록 설정
      width: MediaQuery.of(context).size.width * 0.9,
      height: 60, // 버튼 높이를 살짝 키워 터치감 개선
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30), // 알약 모양(Stadium) 디자인
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6), // 버튼이 떠 있는 듯한 입체감
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: labelStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}