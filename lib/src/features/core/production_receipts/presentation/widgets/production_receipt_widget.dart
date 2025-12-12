import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import '../../../../../core/constants/asset_paths.dart';

class ProductionReceiptWidget extends StatelessWidget {
  final ProductionReceiptEntity item;
  final VoidCallback onTap;

  const ProductionReceiptWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppPalette.primaryColor.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Transform.scale(
                scale: 0.5,
                child: Image.asset(
                  AppAssets.purchaseOrderIcon,
                  color: AppPalette.primaryColor,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'TR #${item.trNumber}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomText(
                        text: '${item.plant}/${item.storageLocation}',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _detailRow("Requirement: ${item.requirementNumber.isEmpty ? 'N/A' : item.requirementNumber}"),
                  SizedBox(height: 4.h),
                  _detailRow("Material Doc: ${item.materialDocument}"),
                  SizedBox(height: 4.h),
                  _detailRow("Created On: ${_formatDateTime(item.createdOn, item.timeOfCreation)}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String dateStr, String timeStr) {
    try {
      final date = DateTime.parse(dateStr);
      final formattedDate = DateFormat('d/M/yyyy').format(date);
      return '$formattedDate ${_formatTime(timeStr)}';
    } catch (_) {
      return '$dateStr $timeStr';
    }
  }

  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute$period';
      }
      return timeStr;
    } catch (_) {
      return timeStr;
    }
  }

  Widget _detailRow(String text) => CustomText(
        text: "• $text",
        fontSize: 12.3.sp,
        color: AppPalette.darkGreyColor,
      );
}

