// 1. 메타데이터 모델 (리스트용)
import 'package:baroallgi/features/article/models/article_type_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel {
  final String id;
  final String title;
  final String authorId;
  final String authorName;
  final ArticleType articleType;
  final String category;
  final String summary;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? thumbnailUrl;

  ArticleModel({
    required this.id,
    required this.title,
    required this.authorId,
    required this.authorName,
    required this.articleType,
    required this.category,
    required this.summary,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnailUrl,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => _$ArticleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}
