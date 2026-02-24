import 'package:baroallgi/features/article/models/article_card_model.dart';
import 'package:baroallgi/features/article/models/article_post_model.dart';
import 'package:baroallgi/features/article/models/article_reference_model.dart';
import 'package:baroallgi/features/article/models/article_type_enum.dart';

abstract class ArticleCommonModel {
  final String articleId;
  final List<ArticleReferenceModel>? references;

  ArticleCommonModel({required this.articleId, this.references});

  factory ArticleCommonModel.fromJson(Map<String, dynamic> json, ArticleType type) {
    switch (type) {
      case ArticleType.CARD:
        return ArticleCardModel.fromJson(json);
      case ArticleType.POST:
      case ArticleType.NEWS:
        return ArticlePostModel.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}
