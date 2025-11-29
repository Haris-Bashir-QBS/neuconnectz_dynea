import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class OutboundDeliveryStoItemCard extends StatelessWidget {
  final OutboundDeliveryStoItemEntity item;
  final VoidCallback? onTap;

  const OutboundDeliveryStoItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: item.itemDescription,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomText(
                        text: '${item.deliveryQuantity.toStringAsFixed(2)} ${item.baseUom}',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _detailRow('Material: ${item.material}'),
                  SizedBox(height: 4.h),
                  _detailRow('Batch: ${item.batch}'),
                  SizedBox(height: 4.h),
                  _detailRow('Item: ${item.item}'),
                  SizedBox(height: 4.h),
                  _detailRow('Status: ${item.itemOverallStatus}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String text) => CustomText(
        text: '• $text',
        fontSize: 12.3.sp,
        color: AppPalette.greyColor,
      );
}
