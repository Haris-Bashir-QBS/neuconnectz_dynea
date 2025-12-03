import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import '../../../../../core/constants/app_texts.dart';
import '../../../../../core/constants/asset_paths.dart';

class GrnListItemWidget extends StatelessWidget {
  final GrnEntity item;
  final String formattedDate;
  final VoidCallback onTap;

  const GrnListItemWidget({
    super.key,
    required this.item,
    required this.formattedDate,
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
                          text: item.name,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomText(
                        text: item.purchaseOrder,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _detailRow("${AppTexts.trNumber}: ${item.trNumber}"),
                  SizedBox(height: 4.h),
                  _detailRow(
                    "${AppTexts.numberofItems} : ${item.numberOfItems}",
                  ),
                  SizedBox(height: 4.h),
                  _detailRow("${AppTexts.createdOn}: $formattedDate"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String text) => CustomText(
    text: "• $text",
    fontSize: 12.3.sp,
    color: AppPalette.darkGreyColor,
  );
}
