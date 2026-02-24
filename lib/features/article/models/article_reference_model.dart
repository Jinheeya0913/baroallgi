import 'package:json_annotation/json_annotation.dart';

part 'article_reference_model.g.dart';

@JsonSerializable()
class ArticleReferenceModel {

  final String title;  // 근거 자료의 제목 (예: '금융감독원 보이스피싱 가이드라인')
  final String url;    // 연결 링크
  final String? type;  // 자료 유형 (뉴스, 공공기관, 법령, 논문 등)
  final String? siteName; // 사이트 이름 (예: '법제처', '네이버 뉴스')

  ArticleReferenceModel({
    required this.title,
    required this.url,
    this.type,
    this.siteName,
  });

  factory ArticleReferenceModel.fromJson(Map<String, dynamic> json) => _$ArticleReferenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleReferenceModelToJson(this);
}



