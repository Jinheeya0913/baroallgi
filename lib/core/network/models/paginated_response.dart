import 'package:cloud_firestore/cloud_firestore.dart';

class PaginatedResponse<T> {
  final List<T> items;
  final DocumentSnapshot? lastDoc; // 다음 페이지를 위한 책갈피

  PaginatedResponse({required this.items, this.lastDoc});
}