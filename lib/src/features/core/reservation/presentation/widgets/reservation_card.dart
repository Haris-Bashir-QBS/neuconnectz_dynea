import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

import '../../../../../core/constants/asset_paths.dart';

class ReservationCard extends StatelessWidget {
  final ReservationEntity? item;
  final String? formattedDate;
  final VoidCallback? onTap;

  const ReservationCard({super.key, this.item, this.formattedDate, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
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
                          CustomText(
                            text: item!.reservation.toString(),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                          CustomText(
                            text:
                                "${item!.receivingPlant}/${item!.receivingStorLoc}",
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: AppPalette.darkGreyColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      _detailRow('Status: ${item!.reservStatus}'),
                      SizedBox(height: 4.h),
                      _detailRow('Requirement Type: ${item!.requirementType}'),
                      SizedBox(height: 4.h),
                      _detailRow('Date: $formattedDate'),
                    ],
                  ),
                ),
              ],
            ),
          ),
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


