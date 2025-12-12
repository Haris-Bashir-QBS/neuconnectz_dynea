import 'dart:ui';

class StockTransferOrderModel {
  final String id;
  final String title;
  final String description;
  final String leadingIconPath;
  final Color leadingIconBackgroundColor;
  final VoidCallback onTap;

  StockTransferOrderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.leadingIconPath,
    required this.leadingIconBackgroundColor,
    required this.onTap,
  });

  StockTransferOrderModel copyWith({
    String? id,
    String? title,
    String? leadingIconPath,
    Color? leadingIconBackgroundColor,
    String? description,
    VoidCallback? onTap,
  }) {
    return StockTransferOrderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      leadingIconPath: leadingIconPath ?? this.leadingIconPath,
      leadingIconBackgroundColor:
          leadingIconBackgroundColor ?? this.leadingIconBackgroundColor,
      description: description ?? this.description,
      onTap: onTap ?? this.onTap,
    );
  }
}


