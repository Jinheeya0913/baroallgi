import 'package:baroallgi/features/article/models/article_common_model.dart';
import 'package:baroallgi/features/article/models/article_model.dart';
import 'package:baroallgi/core/enum/article_type_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleDatasource {
  final FirebaseFirestore _firestore;

  ArticleDatasource(this._firestore);

  static const String _articlePath = 'articles';
  static const String _detailPath = 'article_details';

  CollectionReference get articleCollection =>
      _firestore.collection(_articlePath);

  Future<void> saveArticleBatch({
    required ArticleModel mainInfo,
    required ArticleCommonModel detailInfo,
  }) async {
    final batch = _firestore.batch();

    // repo에서 생성했기 때문에 not null
    final id = mainInfo.id!;

    final mainDocRef = _firestore.collection(_articlePath).doc(id);
    final detailDocRef = mainDocRef.collection(_detailPath).doc(id);

    // 로그 출력
    print('rlog :: mainInfo.toJson :: ${mainInfo.toJson()}');
    print('rlog :: detailInfo.toJson :: ${detailInfo.toJson()}');

    // 정보 저장
    batch.set(mainDocRef, mainInfo.toJson());
    batch.set(detailDocRef, detailInfo.toJson());

    await batch.commit();
  }

  // 페이지네이션이 적용된 리스트 검색
  Future<QuerySnapshot<Map<String, dynamic>>> selectArticleList({
    String? keyword,
    ArticleSelectType? selectType,
    DocumentSnapshot? lastDocument,
    int limit = 10,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(_articlePath);

    if (keyword != null && keyword.isNotEmpty) {
      String field;

      switch (selectType) {
        case ArticleSelectType.TITLE:
          field = 'title';
          break;
        case ArticleSelectType.AUTHOR:
          field = 'authorName';
          break;
        case ArticleSelectType.CATEGORY:
          field = 'category';
        default:
          field = 'title';
      }
      
      print('rlog :: keyword : ${keyword},  field : ${field}');


      query = query
          .where(field, isGreaterThanOrEqualTo: keyword)
          .where(field, isLessThan: '${keyword}\uf8ff')
          .orderBy(field);
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.limit(limit).get();
  }

  String getGenerateId() {
    return _firestore.collection(_articlePath).doc().id;
  }
}
