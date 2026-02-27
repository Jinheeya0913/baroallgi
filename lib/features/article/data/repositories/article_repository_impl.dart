import 'dart:io';

import 'package:baroallgi/core/const/const_code.dart';
import 'package:baroallgi/core/network/models/base_response.dart';
import 'package:baroallgi/core/provider/storage_provider.dart';
import 'package:baroallgi/features/article/data/datasources/article_remote_datasource.dart';
import 'package:baroallgi/features/article/data/repositories/article_repository.dart';
import 'package:baroallgi/features/article/models/article_card_model.dart';
import 'package:baroallgi/features/article/models/article_model.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleDatasource _datasource;
  final FireStorageProvider _storage;

  ArticleRepositoryImpl({
    required ArticleDatasource datasource,
    required FireStorageProvider storage,
  }) : _datasource = datasource,
       _storage = storage;

  // 카드뉴스 전용
  @override
  Future<BaseResponse> saveArticleCard({
    required ArticleModel mainInfo,
    required List<CardDataModel> cardDataList,
    int? thumbnailIndex,
  }) async {
    final articleId = _datasource.getGenerateId();
    bool isUploaded = false;
    List<String> uploadedUrls = [];

    print('rlog :: cardlist : ${cardDataList}');

    // 1. 이미지 업로드 수행
    try {
      uploadedUrls = await _storage.uploadMultipleImages(
        path: 'articles',
        files: cardDataList.map((e) => e.file).toList(),
        type: mainInfo.articleType.name,
        id: articleId,
      );

      // if (uploadedUrls.isEmpty) throw Exception("Upload empty");

      isUploaded = true;
    } catch (e) {
      // 업로드 자체 실패 시 롤백 (부분 업로드 방지)
      print('rlog error ::${REQUEST_FILE_SAVE_FAILED} ::  ${e}');
      return BaseResponse.failResult(
        resultCode: REQUEST_FILE_SAVE_FAILED,
        resultMsg: '이미지 서버 저장 중 오류가 발생했습니다.',
      );
    }

    uploadedUrls = ['https://firebasestorage.googleapis.com/v0/b/baroallgi-2086b.firebasestorage.app/o/articles%2FUUN9fBuw6FSshwx3toeN%2Fimage_CARD_UUN9fBuw6FSshwx3toeN_0.jpg?alt=media&token=08cfefe4-7163-4b25-8835-c37c818dcb91', 'https://firebasestorage.googleapis.com/v0/b/baroallgi-2086b.firebasestorage.app/o/articles%2FUUN9fBuw6FSshwx3toeN%2Fimage_CARD_UUN9fBuw6FSshwx3toeN_1.jpg?alt=media&token=aa30d127-657f-4b48-999d-739664d38d67', 'https://firebasestorage.googleapis.com/v0/b/baroallgi-2086b.firebasestorage.app/o/articles%2FUUN9fBuw6FSshwx3toeN%2Fimage_CARD_UUN9fBuw6FSshwx3toeN_2.jpg?alt=media&token=268848b0-f14a-4e9a-9098-1b6427bddac1'];
    print('rlog :: uploadedUrls : ${uploadedUrls}');
    
    // 2. DB 저장 수행
    try {
      // 썸네일 결정 로직
      String? thumbnailUrl;
      if (thumbnailIndex != null && thumbnailIndex >= 0 && thumbnailIndex < uploadedUrls.length) {
        thumbnailUrl = uploadedUrls[thumbnailIndex];
      } else {
        thumbnailUrl = uploadedUrls.firstOrNull;
      }

      // 카드 데이터 가공
      final cardList = List.generate(uploadedUrls.length, (i) {
        print('rlog :: order : ${i}, imageUrl : ${uploadedUrls[i]}, catpion : ${cardDataList[i].caption}');
        return CardItem(
          order: i,
          imageUrl: uploadedUrls[i],
          caption: cardDataList[i].caption,
        );
      });

      
      final resultMain = mainInfo.copyWith(id: articleId, thumbnailUrl: thumbnailUrl);
      final resultDetail = ArticleCardModel(articleId: articleId, cards: cardList);

      // 🚀 Firestore Batch 실행
      await _datasource.saveArticleBatch(
        mainInfo: resultMain,
        detailInfo: resultDetail,
      );

      // 성공 시 생성된 ID를 data에 담아 반환 (이동 로직에 활용)
      return BaseResponse.successResult(data: articleId);

    } catch (e) {
      // DB 저장 실패 시 스토리지 롤백
      print('rlog :: e :: ${e}');
      // if (isUploaded) {
      //   await _storage.deleteFolder(filePath: 'articles/$articleId');
      // }
      return BaseResponse.failResult(resultMsg: '데이터베이스 저장에 실패하였습니다.');
    }
  }
}
