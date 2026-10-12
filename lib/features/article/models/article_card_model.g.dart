// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleCardModel _$ArticleCardModelFromJson(Map<String, dynamic> json) =>
    ArticleCardModel(
      articleId: json['articleId'] as String,
      cards: (json['cards'] as List<dynamic>?)
          ?.map((e) => CardItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      references: (json['references'] as List<dynamic>?)
          ?.map((e) =>
              ArticleReferenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticleCardModelToJson(ArticleCardModel instance) =>
    <String, dynamic>{
      'articleId': instance.articleId,
      'references': instance.references?.map((e) => e.toJson()).toList(),
      'cards': instance.cards?.map((e) => e.toJson()).toList(),
    };

CardItem _$CardItemFromJson(Map<String, dynamic> json) => CardItem(
      imageUrl: json['imageUrl'] as String?,
      caption: json['caption'] as String?,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$CardItemToJson(CardItem instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'caption': instance.caption,
      'order': instance.order,
    };
