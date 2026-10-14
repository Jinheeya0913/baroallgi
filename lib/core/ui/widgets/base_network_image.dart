import 'package:baroallgi/core/const/const_color.dart';
import 'package:flutter/material.dart';

/// 네트워크 이미지가 디코드되기 전에는 칸 크기를 유지한 채 로딩만 보여 준다.
class BaseNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  /// 로딩이 끝난 뒤 호출된다. [child]는 디코드된 이미지이거나 실패 표시다.
  final Widget Function(BuildContext context, Widget child)? builder;

  const BaseNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.subColorGhost),
        Image.network(
          url,
          fit: fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            final ready = wasSynchronouslyLoaded || frame != null;
            if (!ready) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            return _resolve(context, child);
          },
          errorBuilder: (context, error, stackTrace) {
            return _resolve(context, const _NetworkImageError());
          },
        ),
      ],
    );
  }

  Widget _resolve(BuildContext context, Widget child) {
    final builder = this.builder;
    if (builder == null) return child;
    return builder(context, child);
  }
}

class _NetworkImageError extends StatelessWidget {
  const _NetworkImageError();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: AppColors.primaryNavy),
        Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.white70,
            size: 36,
          ),
        ),
      ],
    );
  }
}
