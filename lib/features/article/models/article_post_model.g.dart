// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlePostModel _$ArticlePostModelFromJson(Map<String, dynamic> json) =>
    ArticlePostModel(
      articleId: json['articleId'] as String,
      content: json['content'] as Map<String, dynamic>,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      references: (json['references'] as List<dynamic>?)
          ?.map((e) =>
              ArticleReferenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticlePostModelToJson(ArticlePostModel instance) =>
    <String, dynamic>{
      'articleId': instance.articleId,
      'references': instance.references,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
    };
