import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  final List<T> results;

  final int totalResults;
  final int itemsPerPage;

  const PaginatedResponse({
    this.results = const [],
    this.itemsPerPage = 11,
    this.totalResults = 1,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json, {
    required List<T> results,
  }) {
    return PaginatedResponse<T>(
        results: results, totalResults: json['count'], itemsPerPage: 11);
  }
  Map<String, dynamic> toJson() => {
        "items_per_page": itemsPerPage,
        "total_results": totalResults,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [itemsPerPage];
}
