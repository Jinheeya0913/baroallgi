import 'package:baroallgi/features/article/models/article_model.dart';
import 'package:baroallgi/features/article/models/article_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ArticleModel json round trip keeps Firestore enum names', () {
    final createdAt = DateTime.utc(2026, 1, 2, 3, 4, 5);
    final model = ArticleModel(
      id: 'article-1',
      title: '부고 문자',
      authorId: 'user-1',
      authorName: '바로알기',
      articleType: ArticleType.CARD,
      category: 'rumor',
      summary: '링크를 누르지 않는다',
      isPublished: true,
      createdAt: createdAt,
      thumbnailUrl: 'https://example.com/thumb.jpg',
    );

    final json = model.toJson();
    final restored = ArticleModel.fromJson(json);

    expect(json['articleType'], 'CARD');
    expect(restored.id, model.id);
    expect(restored.title, model.title);
    expect(restored.authorId, model.authorId);
    expect(restored.authorName, model.authorName);
    expect(restored.articleType, ArticleType.CARD);
    expect(restored.category, model.category);
    expect(restored.summary, model.summary);
    expect(restored.isPublished, true);
    expect(restored.createdAt, createdAt);
    expect(restored.thumbnailUrl, model.thumbnailUrl);
  });
}
