import 'package:baroallgi/features/article/models/article_common_model.dart';
import 'package:baroallgi/features/article/models/article_reference_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_post_model.g.dart';

@JsonSerializable()
class ArticlePostModel extends ArticleCommonModel {
  final Map<String, dynamic> content; // Quill Delta 데이터
  final List<String>? imageUrls;

  ArticlePostModel({
    required super.articleId,
    required this.content,
    this.imageUrls,
    super.references,
  });

  @override
  ArticlePostModel copyWith({
    String? articleId,
    List<ArticleReferenceModel>? references,
    Map<String, dynamic>? content, List<String>? imageUrls, // PostModel만의 필드 추가
  }) {
    return ArticlePostModel(
      articleId: articleId ?? this.articleId,
      references: references ?? this.references,
      imageUrls: imageUrls ?? imageUrls,
      content: content ?? this.content,
    );
  }


  factory ArticlePostModel.fromJson(Map<String, dynamic> json) => _$ArticlePostModelFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$ArticlePostModelToJson(this);
}
