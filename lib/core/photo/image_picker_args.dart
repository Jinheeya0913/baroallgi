import 'package:baroallgi/features/article/models/article_model.dart';

class ImagePickerArgs {
  final String nextRoute;
  final String? pageTitle;
  final ArticleModel article;

  const ImagePickerArgs({
    required this.nextRoute,
    required this.article,
    this.pageTitle,
  });
}
