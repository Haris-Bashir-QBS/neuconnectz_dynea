abstract class PaginatedResponse<T> {
  List<T>? get items;
  int? get totalCount;
}
