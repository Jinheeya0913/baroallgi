import 'package:baroallgi/core/provider/select_image_provider.dart';
import 'package:baroallgi/core/ui/widgets/TextEditSheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class CardEditPage extends HookConsumerWidget {
  static String get routeName => 'cardEdit';

  const CardEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectImageProvider);
    final imageTexts = ref.watch(imageTextProvider);
    final pageController = usePageController();
    final currentPage = useState(1);

    return DefaultLayout(
      useAppBar: false,
      padding: EdgeInsets.zero, // 배경을 꽉 채우기 위해 0
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1A1A1A), // 편집 집중도를 높이는 어두운 배경
        child: Stack(
          children: [
            // 1. 카드뉴스 편집 뷰
            PageView.builder(
              controller: pageController,
              onPageChanged: (index) => currentPage.value = index + 1,
              itemCount: selectedImages.length,
              allowImplicitScrolling: true,
              itemBuilder: (context, index) {
                final asset = selectedImages[index];
                final currentText = imageTexts[asset.id] ?? "";
                final hasText = currentText.isNotEmpty;

                return _KeepAlivePage(
                  child: Column(
                    children: [
                      // ✅ [조정] 상단 바와 카드뉴스 사이의 간격을 100으로 늘려 시원하게 배치
                      const SizedBox(height: 100),

                      // [카드뉴스 캔버스]
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            )
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.black,
                              child: AssetEntityImage(
                                asset,
                                thumbnailSize: const ThumbnailSize.square(1200),
                                isOriginal: false,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // [하단 텍스트 영역]
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showTextEditDialog(context, ref, asset.id, currentText),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.format_quote_rounded, color: Colors.white.withOpacity(0.1), size: 45),
                                const SizedBox(height: 15),
                                Text(
                                  hasText ? currentText : "여기를 눌러서\n멋진 문구를 추가해보세요",
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: hasText ? Colors.white : Colors.white24,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 2. 상단 네비게이션 (고정)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "${currentPage.value} / ${selectedImages.length}",
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("완료", style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. ✅ [화이트 톤] 바텀 시트 호출
  void _showTextEditDialog(BuildContext context, WidgetRef ref, String assetId, String initialText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //backgroundColor: Colors.transparent, // 외부 둥근 모서리 표현용
      builder: (context) {
        // 내부 디자인은 TextEditSheet 위젯에서 화이트 톤으로 처리되어야 함
        return TextEditSheet(
          initialText: initialText,
          onSave: (text) {
            ref.read(imageTextProvider.notifier).update((state) => {
              ...state,
              assetId: text,
            });
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------
// 사진 및 렌더링 상태 유지를 위한 위젯
// ---------------------------------------------------------
class _KeepAlivePage extends StatefulWidget {
  final Widget child;
  const _KeepAlivePage({required this.child});
  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}