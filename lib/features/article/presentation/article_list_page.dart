import 'package:baroallgi/core/const/app_metadata.dart';
import 'package:baroallgi/core/const/const_color.dart';
import 'package:baroallgi/core/enum/article_type_enum.dart';
import 'package:baroallgi/core/ui/widgets/base_text_field.dart';
import 'package:baroallgi/features/article/provider/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';

class ArticleListPage extends HookConsumerWidget {
  static String get routeName => 'article_list';

  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. ArticleProvider 감시
    final provider = ref.watch(articleNotifier);
    final scrollController = useScrollController();
    final selectedCategory = useState<String?>(null);

    // 2. 페이지 진입 시 최초 데이터 로드
    useEffect(() {
      // 이미 데이터가 있다면 다시 불러오지 않음 (캐싱 효과)
      if (provider.articles.isEmpty) {
        Future.microtask(() => provider.fetchArticles());
      }
      return null;
    }, []);

    // 3. 무한 스크롤 감지 로직
    useEffect(() {
      void scrollListener() {
        // 스크롤이 끝에 도달하기 전(남은 거리 200px)에 미리 다음 페이지 호출
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          provider.fetchArticles();
        }
      }

      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, [scrollController]);

    return DefaultLayout(
      useAppBar: false,
      child: Column(
        children: [

          // 검색바 (필요 시 provider.reset()과 연동)
          BaseTextField(
            hintText: '검색어를 입력하세요',
            onFieldSubmitted: (value){
              provider.reset();
              provider.fetchArticles(
                keyword: value,
                selectType: ArticleSelectType.TITLE,
              );
            },
          ),

          // 2. 카테고리 필터 (가로 스크롤 칩)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // '전체' 버튼
                _CategoryChip(
                  label: '전체',
                  isSelected: selectedCategory.value == null,
                  onTap: () {
                    selectedCategory.value = null;
                    provider.reset();
                    provider.fetchArticles(keyword: selectedCategory.value, selectType: ArticleSelectType.CATEGORY);
                  },
                ),
                // AppMetadata에서 가져온 카테고리들
                ...AppMetadata.reportCategories.map((cat) {
                  final categoryName = cat['name'] as String;
                  final categoryId = cat['id'] as String;
                  return _CategoryChip(
                    label: categoryName,
                    isSelected: selectedCategory.value == categoryId,
                    onTap: () {
                      selectedCategory.value = categoryId;
                      provider.reset();
                      provider.fetchArticles(
                        keyword: categoryId,
                        selectType: ArticleSelectType.CATEGORY, // CATEGORY 타입 사용
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),


          // 리스트 영역
          Expanded(child: _buildListBody(provider, scrollController, ref)),
        ],
      ),
    );
  }

  Widget _buildListBody(
    ArticleProvider provider,
    ScrollController scrollController,
    WidgetRef ref,
  ) {
    // 최초 로딩 중
    if (provider.isLoading && provider.articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 데이터가 아예 없는 경우
    if (provider.articles.isEmpty && provider.isLastPage) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        provider.reset();
        await provider.fetchArticles();
      },
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.articles.length + (provider.isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          // 리스트 하단 로딩 바
          if (index == provider.articles.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final article = provider.articles[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: article.thumbnailUrl != null
                  ? Image.network(
                      article.thumbnailUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.article_outlined),
                    ),
            ),
            title: Text(
              article.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${article.authorName} · ${article.category}'),
            onTap: () {
              // 상세 페이지 이동 로직 (ArticleCardViewPage 등)
            },
          );
        },
      ),
    );
  }


}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNavy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryNavy : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
