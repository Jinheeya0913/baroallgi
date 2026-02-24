import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class BaseFloatingButton extends HookConsumerWidget {
  final VoidCallback? onPressed;
  final String label;
  final TextStyle? labelStyle;
  final Color? backgroundColor;

  const BaseFloatingButton({
    super.key,
    this.onPressed,
    required this.label,
    this.labelStyle,
    this.backgroundColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        label: Text(label, style: labelStyle),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
