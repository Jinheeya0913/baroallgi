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

  @override
  ArticleCardModel copyWith({
    String? articleId,
    List<ArticleReferenceModel>? references,
    List<CardItem>? cards,
  }) {
    return ArticleCardModel(
      articleId: articleId ?? this.articleId,
      references: references ?? this.references,
      cards : cards ?? this.cards,
    );
  }

  factory ArticleCardModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleCardModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleCardModelToJson(this);
}

@JsonSerializable()
class CardItem {
  final String? imageUrl;
  final String? caption;
  final int order;

  CardItem({this.imageUrl, this.caption, required this.order});

  CardItem copyWith({
    String? imageUrl,
    String? caption,
    int? order,
  }) {
    return CardItem(
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      order: order ?? this.order,
    );
  }

  factory CardItem.fromJson(Map<String, dynamic> json) =>
      _$CardItemFromJson(json);

  Map<String, dynamic> toJson() => _$CardItemToJson(this);



}
