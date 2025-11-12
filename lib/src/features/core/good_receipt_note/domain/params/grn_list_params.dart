class GrnListParams {
  final String plant;
  final String location;
  final int pageSize;
  final int pageNumber;
  final String? keyword;

  const GrnListParams({
    required this.plant,
    required this.location,
    this.pageSize = 10,
    this.pageNumber = 1,
    this.keyword,
  });
}

