import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class GrnItemWidget extends StatelessWidget {
  final GrnItemEntity item;
  final VoidCallback onTap;

  const GrnItemWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Material description & batch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: item.materialDescription,
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

                  // Material No & Quantity
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

            // Tap to Process bar
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
                    text: 'UOM: ${item.baseUOM}',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppPalette.whiteColor,
                  ),
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
