import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class InboundDeliveryItemWidget extends StatelessWidget {
  final InboundDeliveryItemEntity item;
  final VoidCallback onTap;

  const InboundDeliveryItemWidget({
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
                          text: item.materialDescription ?? 'N/A',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CustomText(
                        text: item.quantity.formatWithCommas,
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
                        text: 'Material No: ${item.materialNo ?? "N/A"}',
                        fontSize: 12.sp,
                        color: AppPalette.greyColor,
                      ),
                      CustomText(
                        text:
                            'Batch No: ${item.batchNo.isEmpty ? "N/A" : item.batchNo}',
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
                  // CustomText(
                  //   text: 'UOM: ${item. ?? "N/A"}',
                  //   fontSize: 12.sp,
                  //   fontWeight: FontWeight.w400,
                  //   color: AppPalette.whiteColor,
                  // ),
                  Spacer(),
                  CustomText(
                    text: 'Tap to Process',
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
