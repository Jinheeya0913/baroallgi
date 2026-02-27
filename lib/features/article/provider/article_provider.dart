import 'package:baroallgi/core/provider/firebase_provider.dart';
import 'package:baroallgi/core/provider/storage_provider.dart';
import 'package:baroallgi/features/article/data/datasources/article_remote_datasource.dart';
import 'package:baroallgi/features/article/data/repositories/article_repository.dart';
import 'package:baroallgi/features/article/data/repositories/article_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// [Data Layer]
// Datasource를 제공하는 Provider
final articleDatasourceProvider = Provider<ArticleDatasource>((ref) {
  // firestore 인스턴스를 주입하여 Datasource를 생성
  return ArticleDatasource(ref.watch(firestoreProvider));
});

// [Domain Layer]
// Repository의 구현체(Impl)를 제공하는 Provider
// UI는 이 Provider를 통해 데이터 로직에 접근
final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  // Repository 구현체에 필요한 모든 부품(다른 Provider)들을 주입
  return ArticleRepositoryImpl(
    datasource: ref.watch(articleDatasourceProvider),
    storage:   ref.watch(fireStorageProvider),
  );
});
