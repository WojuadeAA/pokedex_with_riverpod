class PaginatedResponse<T> {
  final List<T> results;

  final int totalResults;
  final int itemsPerPage;

  PaginatedResponse({
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
}
