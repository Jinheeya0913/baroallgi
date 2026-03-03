import 'package:baroallgi/core/enum/article_type_enum.dart';
import 'package:baroallgi/core/provider/firebase_provider.dart';
import 'package:baroallgi/core/provider/storage_provider.dart';
import 'package:baroallgi/features/article/data/datasources/article_remote_datasource.dart';
import 'package:baroallgi/features/article/data/repositories/article_repository.dart';
import 'package:baroallgi/features/article/data/repositories/article_repository_impl.dart';
import 'package:baroallgi/features/article/models/article_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// [Data Layer]
final articleDatasourceProvider = Provider<ArticleDatasource>((ref) {
  return ArticleDatasource(ref.watch(firestoreProvider));
});

// [Domain Layer]
final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepositoryImpl(
    datasource: ref.watch(articleDatasourceProvider),
    storage: ref.watch(fireStorageProvider),
  );
});

// [Presentation Layer]
final articleNotifier = ChangeNotifierProvider<ArticleProvider>((ref) {
  return ArticleProvider(repository: ref.watch(articleRepositoryProvider));
});

class ArticleProvider extends ChangeNotifier {
  final ArticleRepository _repository;

  List<ArticleModel> articles = [];
  DocumentSnapshot? _lastDoc;
  bool isLastPage = false;
  bool isLoading = false; // 중복 로딩 방지

  ArticleProvider({required ArticleRepository repository})
      : _repository = repository;

  /// 게시글 가져오기 (무한 스크롤 대응)
  Future<void> fetchArticles({String? keyword, ArticleSelectType? selectType}) async {
    if (isLastPage || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getArticleList(
        keyword: keyword,
        selectType: selectType,
        lastDocument: _lastDoc,
      );

      if (response != null) {
        final items = response.items as List<ArticleModel>;

        // 10개 미만으로 가져오면 마지막 페이지로 간주
        if (items.length < 10) isLastPage = true;

        articles.addAll(items);
        _lastDoc = response.lastDoc;
      }
    } catch (e) {
      debugPrint('rlog :: fetchArticles error : $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 리스트 초기화 (검색어나 필터 변경 시 사용)
  void reset() {
    articles = [];
    _lastDoc = null;
    isLastPage = false;
    isLoading = false;
    notifyListeners();
  }
}
