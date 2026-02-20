import 'package:baroallgi/core/provider/select_image_provider.dart';
import 'package:baroallgi/core/ui/widgets/TextEditSheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class CardEditPage extends HookConsumerWidget {
  static String get routeName => 'cardEdit';

  const CardEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    // 선택된 사진 리스트 가져오기
    final selectedImages = ref.watch(selectImageProvider);
    final imageTexts = ref.watch(imageTextProvider);

    // PageView 컨트롤러
    final pageController = usePageController();

    return DefaultLayout(
      title: const Text("문구 편집"),
      useBackBtn: true,
      padding: 0, // 화면을 꽉 채우기 위해 패딩 제거 (DefaultLayout 설정에 따라 조절)
      child: PageView.builder(
        controller: pageController,
        itemCount: selectedImages.length,
        itemBuilder: (context, index) {
          final asset = selectedImages[index];
          final currentText = imageTexts[asset.id] ?? "여기를 눌러 문구를 입력하세요";

          return Column(
            children: [
              // 1. 상단 2/3 : 사진 영역
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: AssetEntityImage(
                    asset,
                    isOriginal: true, // 편집 화면이므로 고화질
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // 2. 하단 1/3 : 그라데이션 및 텍스트 영역
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => _showTextEditDialog(context, ref, asset.id, imageTexts[asset.id] ?? ""),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      // 감성적인 처리를 위한 그라데이션
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.grey, Colors.black87],
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      currentText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  // 3. 텍스트 입력을 위한 팝업 (BottomSheet)
  void _showTextEditDialog(BuildContext context, WidgetRef ref, String assetId, String initialText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드 높이에 맞게 조절
      builder: (context) {
        return TextEditSheet(
          initialText: initialText,
          onSave: (text) {
            // 해당 이미지 ID에 텍스트 저장
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
