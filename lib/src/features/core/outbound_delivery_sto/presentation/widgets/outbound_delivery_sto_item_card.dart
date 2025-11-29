import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class OutboundDeliveryStoItemCard extends StatelessWidget {
  final OutboundDeliveryStoItemEntity item;
  final String? ctoText;
  final VoidCallback onTap;

  const OutboundDeliveryStoItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.ctoText,
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
                  _itemNameAndQuantity(),
                  SizedBox(height: 8.h),
                  _materialAndBatch(),
                  SizedBox(height: 6.h),
                  _itemNumberAndStatus(),
                ],
              ),
            ),
            _oumAndTapToProcessText(),
          ],
        ),
      ),
    );
  }

  Container _oumAndTapToProcessText() {
    return Container(
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
          const Spacer(),
          CustomText(
            text: ctoText ?? 'Tap to Process',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppPalette.whiteColor,
          ),
        ],
      ),
    );
  }

  Row _itemNameAndQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomText(
            text: item.itemDescription,
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
    );
  }

  Row _materialAndBatch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: 'Material: ${item.material}',
          fontSize: 12.sp,
          color: AppPalette.greyColor,
        ),
        CustomText(
          text: 'Batch: ${item.batch.isEmpty ? "N/A" : item.batch}',
          fontSize: 12.sp,
          color: AppPalette.greyColor,
        ),
      ],
    );
  }

  Row _itemNumberAndStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: 'Item: ${item.item}',
          fontSize: 12.sp,
          color: AppPalette.greyColor,
        ),
        CustomText(
          text: 'Status: ${item.itemOverallStatus}',
          fontSize: 12.sp,
          color: AppPalette.greyColor,
        ),
      ],
    );
  }
}
