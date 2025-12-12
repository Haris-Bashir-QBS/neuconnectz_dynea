import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class OutboundDeliverySalesItemCard extends StatelessWidget {
  final OutboundDeliverySalesItemEntity item;
  final VoidCallback onTap;
  final String ctaText;

  const OutboundDeliverySalesItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.ctaText = 'Tap to Process',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: item.itemDescription.isNotEmpty
                              ? item.itemDescription
                              : item.material,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CustomText(
                        text: item.deliveryQuantity.formatWithCommas,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Material No: ${item.material}',
                        fontSize: 12.sp,
                        color: AppPalette.greyColor,
                      ),
                      CustomText(
                        text:
                            'Batch No: ${item.batch.isEmpty ? "N/A" : item.batch}',
                        fontSize: 12.sp,
                        color: AppPalette.greyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppPalette.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Row(
                children: [
                  CustomText(
                    text: 'UOM: ${item.baseUom}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppPalette.whiteColor,
                  ),
                  Spacer(),
                  CustomText(
                    text: ctaText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppPalette.whiteColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



