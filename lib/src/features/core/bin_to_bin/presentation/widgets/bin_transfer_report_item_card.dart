import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class BinTransferReportItemCard extends StatelessWidget {
  final BinTransferReportEntity report;
  final VoidCallback? onTap;

  const BinTransferReportItemCard({
    super.key,
    required this.report,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w).copyWith(top: 16.h, bottom: 16.h),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.red, size: 18.sp),
                      8.horizontalSpace,
                      CustomText(
                        text: 'From Bin',
                        fontSize: 12.sp,
                        color: AppPalette.greyColor,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  CustomText(
                    text:
                        '${report.sourceStorageType}-${report.sourceStorageSection}-${report.sourceStorageBin}',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.darkGreyColor,
                  ),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.green,
                        size: 18.sp,
                      ),
                      8.horizontalSpace,
                      CustomText(
                        text: 'To Bin',
                        fontSize: 12.sp,
                        color: AppPalette.greyColor,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  CustomText(
                    text:
                        '${report.destinationStorageType}-${report.destinationStorageSection}-${report.destinationStorageBin}',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.darkGreyColor,
                    textAlign: TextAlign.right,
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
