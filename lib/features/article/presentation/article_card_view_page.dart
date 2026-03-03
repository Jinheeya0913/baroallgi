import 'package:baroallgi/features/article/models/article_card_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';

class ArticleCardViewPage extends HookConsumerWidget {
  static String get routeName => 'article_card_view';
  
  final Map<String,dynamic> data;

  const ArticleCardViewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = data['detail'];
    final model = ArticleCardModel.fromJson(details);
    final cards = model.cards ?? [];
    final pageController = usePageController();
    final currentPage = useState(1);

    return DefaultLayout(
      useAppBar: false,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1A1A1A), // 편집 페이지와 동일한 어두운 배경
        child: Stack(
          children: [
            // 1. 카드뉴스 슬라이드 뷰
            PageView.builder(
              controller: pageController,
              onPageChanged: (index) => currentPage.value = index + 1,
              itemCount: cards.length,
              allowImplicitScrolling: true,
              itemBuilder: (context, index) {
                final card = cards[index];
                final hasText = card.caption != null && card.caption!.isNotEmpty;

                return Column(
                  children: [
                    const SizedBox(height: 100),

                    // [카드뉴스 이미지 캔버스]
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.black,
                            child: card.imageUrl != null
                                ? Image.network(
                                    card.imageUrl!,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white24,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Center(
                                      child: Icon(Icons.error_outline,
                                          color: Colors.white24),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ),

                    // [하단 텍스트 영역]
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_quote_rounded,
                              color: Colors.white.withOpacity(0.1),
                              size: 45,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              hasText ? card.caption! : "",
                              textAlign: TextAlign.center,
                              maxLines: 5,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // 2. 상단 네비게이션 및 페이지 인디케이터
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
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "${currentPage.value} / ${cards.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 우측 밸런스를 위한 더미 공간
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
