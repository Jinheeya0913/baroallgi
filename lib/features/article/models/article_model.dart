// 1. 메타데이터 모델 (리스트용)
import 'package:baroallgi/core/enum/article_type_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel {
  final String? id;
  final String title;
  final String authorId;
  final String authorName;
  final ArticleType articleType;
  final String category;
  final String summary;
  final bool? isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? thumbnailUrl;

  ArticleModel({
    this.id,
    required this.title,
    required this.authorId,
    required this.authorName,
    required this.articleType,
    required this.category,
    required this.summary,
    this.isPublished = false,
    this.createdAt,
    this.updatedAt,
    this.thumbnailUrl,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  // copyWith 메서드 구현
  ArticleModel copyWith({
    String? id,
    String? title,
    String? authorId,
    String? authorName,
    ArticleType? articleType,
    String? category,
    String? summary,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? thumbnailUrl,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      articleType: articleType ?? this.articleType,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
