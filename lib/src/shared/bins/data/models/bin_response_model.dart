import 'package:neuconnectz_dynea/src/shared/bins/data/models/bin_model.dart';

class BinResponseModel {
  final bool isApiHandled;
  final bool isRequestSuccess;
  final int statusCode;
  final String message;
  final BinDataModel? data;
  final List<dynamic> exception;

  BinResponseModel({
    required this.isApiHandled,
    required this.isRequestSuccess,
    required this.statusCode,
    required this.message,
    this.data,
    required this.exception,
  });

  factory BinResponseModel.fromJson(Map<String, dynamic> json) {
    return BinResponseModel(
      isApiHandled: json['isApiHandled'] ?? false,
      isRequestSuccess: json['isRequestSuccess'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? BinDataModel.fromJson(json['data'] as Map<String, dynamic>)
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

class BinDataModel {
  final int totalCount;
  final List<BinModel> data;

  BinDataModel({
    required this.totalCount,
    required this.data,
  });

  factory BinDataModel.fromJson(Map<String, dynamic> json) {
    return BinDataModel(
      totalCount: json['totalCount'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => BinModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'totalCount': totalCount,
        'data': data.map((item) => item.toJson()).toList(),
      };
}



