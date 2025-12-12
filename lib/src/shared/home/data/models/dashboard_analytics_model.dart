class DashboardAnalyticsModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final DashboardAnalyticsData? data;
  final List<dynamic> exception;

  DashboardAnalyticsModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.exception,
  });

  factory DashboardAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return DashboardAnalyticsModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? DashboardAnalyticsData.fromJson(json['data'])
              : null,
      exception: json['exception'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'isApiHandled': isApiHandled,
    'isRequestSuccess': isRequestSuccess,
    'statusCode': statusCode,
    'message': message,
    'data': data?.toJson(),
    'exception': exception,
  };
}

class DashboardAnalyticsData {
  final TransferStatisticsModel? transferStatistics;
  final GrnStatisticsModel? grnStatistics;
  final List<TopCreatedItem> topCreatedItems;
  final LastIntegrationDates? lastIntegrationDates;

  DashboardAnalyticsData({
    required this.transferStatistics,
    required this.grnStatistics,
    required this.topCreatedItems,
    required this.lastIntegrationDates,
  });

  factory DashboardAnalyticsData.fromJson(Map<String, dynamic> json) {
    return DashboardAnalyticsData(
      transferStatistics:
          json['transferStatistics'] != null
              ? TransferStatisticsModel.fromJson(json['transferStatistics'])
              : null,
      grnStatistics:
          json['grnStatistics'] != null
              ? GrnStatisticsModel.fromJson(json['grnStatistics'])
              : null,
      topCreatedItems:
          (json['topCreatedItems'] as List<dynamic>? ?? [])
              .map((e) => TopCreatedItem.fromJson(e))
              .toList(),
      lastIntegrationDates:
          json['lastIntegrationDates'] != null
              ? LastIntegrationDates.fromJson(json['lastIntegrationDates'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'transferStatistics': transferStatistics?.toJson(),
    'grnStatistics': grnStatistics?.toJson(),
    'topCreatedItems': topCreatedItems.map((e) => e.toJson()).toList(),
    'lastIntegrationDates': lastIntegrationDates?.toJson(),
  };
}

class TransferStatisticsModel {
  final int totalItrIntegrated;
  final int totalItrPending;
  final int totalItIntegrated;
  final int totalItPending;
  final int totalTrIntegrated;
  final int totalTrPending;

  TransferStatisticsModel({
    required this.totalItrIntegrated,
    required this.totalItrPending,
    required this.totalItIntegrated,
    required this.totalItPending,
    required this.totalTrIntegrated,
    required this.totalTrPending,
  });

  factory TransferStatisticsModel.fromJson(Map<String, dynamic> json) {
    return TransferStatisticsModel(
      totalItrIntegrated: json['totalItrIntegrated'] ?? 0,
      totalItrPending: json['totalItrPending'] ?? 0,
      totalItIntegrated: json['totalItIntegrated'] ?? 0,
      totalItPending: json['totalItPending'] ?? 0,
      totalTrIntegrated: json['totalTrIntegrated'] ?? 0,
      totalTrPending: json['totalTrPending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalItrIntegrated': totalItrIntegrated,
    'totalItrPending': totalItrPending,
    'totalItIntegrated': totalItIntegrated,
    'totalItPending': totalItPending,
    'totalTrIntegrated': totalTrIntegrated,
    'totalTrPending': totalTrPending,
  };
}

class GrnStatisticsModel {
  final int totalGrnIntegrated;
  final int totalGrnPending;

  GrnStatisticsModel({
    required this.totalGrnIntegrated,
    required this.totalGrnPending,
  });

  factory GrnStatisticsModel.fromJson(Map<String, dynamic> json) {
    return GrnStatisticsModel(
      totalGrnIntegrated: json['totalGrnIntegrated'] ?? 0,
      totalGrnPending: json['totalGrnPending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalGrnIntegrated': totalGrnIntegrated,
    'totalGrnPending': totalGrnPending,
  };
}

class TopCreatedItem {
  final String itemCode;
  final int count;

  TopCreatedItem({required this.itemCode, required this.count});

  factory TopCreatedItem.fromJson(Map<String, dynamic> json) {
    return TopCreatedItem(
      itemCode: json['itemCode'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'itemCode': itemCode, 'count': count};
}

class LastIntegrationDates {
  final String lastItrIntegrationDate;
  final String lastItIntegrationDate;
  final String lastTrIntegrationDate;
  final String lastGrnIntegrationDate;

  LastIntegrationDates({
    required this.lastItrIntegrationDate,
    required this.lastItIntegrationDate,
    required this.lastTrIntegrationDate,
    required this.lastGrnIntegrationDate,
  });

  factory LastIntegrationDates.fromJson(Map<String, dynamic> json) {
    return LastIntegrationDates(
      lastItrIntegrationDate: json['lastItrIntegrationDate'] ?? '',
      lastItIntegrationDate: json['lastItIntegrationDate'] ?? '',
      lastTrIntegrationDate: json['lastTrIntegrationDate'] ?? '',
      lastGrnIntegrationDate: json['lastGrnIntegrationDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'lastItrIntegrationDate': lastItrIntegrationDate,
    'lastItIntegrationDate': lastItIntegrationDate,
    'lastTrIntegrationDate': lastTrIntegrationDate,
    'lastGrnIntegrationDate': lastGrnIntegrationDate,
  };
}


