import 'package:baroallgi/features/article/models/article_card_model.dart';
import 'package:baroallgi/features/article/models/article_reference_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ArticleCardModel json round trip keeps cards and references', () {
    final model = ArticleCardModel(
      articleId: 'article-1',
      cards: [
        CardItem(order: 0, imageUrl: 'https://example.com/0.jpg', caption: '첫 장'),
        CardItem(order: 1, caption: '글만'),
      ],
      references: [
        ArticleReferenceModel(
          title: '금융감독원 가이드',
          url: 'https://example.com/guide',
          type: 'public',
          siteName: '금융감독원',
        ),
      ],
    );

    final restored = ArticleCardModel.fromJson(model.toJson());

    expect(restored.articleId, 'article-1');
    expect(restored.cards, hasLength(2));
    expect(restored.cards!.first.order, 0);
    expect(restored.cards!.first.imageUrl, 'https://example.com/0.jpg');
    expect(restored.cards!.first.caption, '첫 장');
    expect(restored.cards![1].imageUrl, isNull);
    expect(restored.references, hasLength(1));
    expect(restored.references!.single.title, '금융감독원 가이드');
    expect(restored.references!.single.url, 'https://example.com/guide');
    expect(restored.references!.single.siteName, '금융감독원');
  });
}
