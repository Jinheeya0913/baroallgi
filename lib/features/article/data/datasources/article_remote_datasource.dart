import 'package:baroallgi/features/article/models/article_common_model.dart';
import 'package:baroallgi/features/article/models/article_model.dart';
import 'package:baroallgi/features/article/models/article_post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/script/upgrade_all_dependencies.dart';

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

  String getGenerateId(){
    return _firestore.collection(_articlePath).doc().id;
  }
}
