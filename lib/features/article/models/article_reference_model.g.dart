// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleReferenceModel _$ArticleReferenceModelFromJson(
        Map<String, dynamic> json) =>
    ArticleReferenceModel(
      title: json['title'] as String,
      url: json['url'] as String,
      type: json['type'] as String?,
      siteName: json['siteName'] as String?,
    );

Map<String, dynamic> _$ArticleReferenceModelToJson(
        ArticleReferenceModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'type': instance.type,
      'siteName': instance.siteName,
    };
