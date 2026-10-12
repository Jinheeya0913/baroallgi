// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      articleType: $enumDecode(_$ArticleTypeEnumMap, json['articleType']),
      category: json['category'] as String,
      summary: json['summary'] as String,
      isPublished: json['isPublished'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'articleType': _$ArticleTypeEnumMap[instance.articleType]!,
      'category': instance.category,
      'summary': instance.summary,
      'isPublished': instance.isPublished,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'thumbnailUrl': instance.thumbnailUrl,
    };

const _$ArticleTypeEnumMap = {
  ArticleType.FULLIMG: 'FULLIMG',
  ArticleType.POST: 'POST',
  ArticleType.CARD: 'CARD',
};
