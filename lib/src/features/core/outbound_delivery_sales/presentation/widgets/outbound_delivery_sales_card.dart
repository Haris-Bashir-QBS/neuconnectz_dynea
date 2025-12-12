import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

import '../../../../../core/constants/asset_paths.dart';

class OutboundDeliverySalesCard extends StatelessWidget {
  final OutboundDeliverySalesEntity item;
  final VoidCallback? onTap;

  const OutboundDeliverySalesCard({super.key, required this.item, this.onTap});

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
                          Expanded(
                            child: CustomText(
                              text: item.delivery,
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
                      _detailRow(
                        'Sales Organization: ${item.salesOrganization}',
                      ),
                      SizedBox(height: 4.h),
                      _detailRow('Delivery Type: ${item.deliveryType}'),
                      SizedBox(height: 4.h),
                      _detailRow(
                        'Receiving Plant: ${item.receivingPlant.isEmpty ? "N/A" : item.receivingPlant}',
                      ),
                      // SizedBox(height: 4.h),
                      // _detailRow('Delivery Block: ${item.deliveryBlock}'),
                      // SizedBox(height: 4.h),
                      // _detailRow('Overall Status: ${item.overallStatus}'),
                      // SizedBox(height: 4.h),
                      // _detailRow('Goods Movement: ${item.goodsMovementSts}'),
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


