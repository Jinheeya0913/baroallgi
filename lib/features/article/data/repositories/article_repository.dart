import 'package:baroallgi/core/network/models/base_response.dart';
import 'package:baroallgi/core/network/models/paginated_response.dart';
import 'package:baroallgi/features/article/models/article_card_model.dart';
import 'package:baroallgi/features/article/models/article_model.dart';
import 'package:baroallgi/core/enum/article_type_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class ArticleRepository {
  Future<BaseResponse> saveArticleCard({
    required ArticleModel mainInfo,
    required List<CardDataModel> cardDataList,
    int? thumbnailIndex,
  });

  Future <PaginatedResponse?> getArticleList(
      {String? keyword, ArticleSelectType? selectType, DocumentSnapshot? lastDocument});

}
