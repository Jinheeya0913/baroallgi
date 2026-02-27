import 'package:baroallgi/core/network/models/base_response.dart';
import 'package:baroallgi/features/article/models/article_card_model.dart';
import 'package:baroallgi/features/article/models/article_model.dart';

abstract class ArticleRepository {
  Future<BaseResponse> saveArticleCard({
    required ArticleModel mainInfo,
    required List<CardDataModel> cardDataList,
    int? thumbnailIndex,
  });
}
