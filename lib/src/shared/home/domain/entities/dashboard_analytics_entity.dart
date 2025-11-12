class DashboardAnalyticsEntity {
  final TransferStatisticsEntity? transferStatistics;
  final GrnStatisticsEntity? grnStatistics;
  final List<TopCreatedItemEntity>? topCreatedItems;
  final LastIntegrationDatesEntity? lastIntegrationDates;

  DashboardAnalyticsEntity({
    this.transferStatistics,
    this.grnStatistics,
    this.topCreatedItems,
    this.lastIntegrationDates,
  });
}

class TransferStatisticsEntity {
  final int? totalItrIntegrated;
  final int? totalItrPending;
  final int? totalItIntegrated;
  final int? totalItPending;
  final int? totalTrIntegrated;
  final int? totalTrPending;

  TransferStatisticsEntity({
    this.totalItrIntegrated,
    this.totalItrPending,
    this.totalItIntegrated,
    this.totalItPending,
    this.totalTrIntegrated,
    this.totalTrPending,
  });
}

class GrnStatisticsEntity {
  final int? totalGrnIntegrated;
  final int? totalGrnPending;

  GrnStatisticsEntity({this.totalGrnIntegrated, this.totalGrnPending});
}

class TopCreatedItemEntity {
  final String? itemCode;
  final int? count;

  TopCreatedItemEntity({this.itemCode, this.count});
}

class LastIntegrationDatesEntity {
  final String? lastItrIntegrationDate;
  final String? lastItIntegrationDate;
  final String? lastTrIntegrationDate;
  final String? lastGrnIntegrationDate;

  LastIntegrationDatesEntity({
    this.lastItrIntegrationDate,
    this.lastItIntegrationDate,
    this.lastTrIntegrationDate,
    this.lastGrnIntegrationDate,
  });
}
