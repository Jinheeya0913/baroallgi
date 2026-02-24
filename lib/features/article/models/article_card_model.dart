import 'package:baroallgi/features/article/models/article_common_model.dart';
import 'package:baroallgi/features/article/models/article_reference_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_card_model.g.dart';

@JsonSerializable()
class ArticleCardModel extends ArticleCommonModel {
  final List<CardItem> cards;

  ArticleCardModel({
    required this.cards,
    required super.articleId,
    super.references,
  });

  factory ArticleCardModel.fromJson(Map<String, dynamic> json) => _$ArticleCardModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleCardModelToJson(this);
}

@JsonSerializable()
class CardItem {
  final String imageUrl;
  final String? caption;
  final int order;

  CardItem({required this.imageUrl, this.caption, required this.order});

  factory CardItem.fromJson(Map<String, dynamic> json) => _$CardItemFromJson(json);
  Map<String, dynamic> toJson() => _$CardItemToJson(this);
}
