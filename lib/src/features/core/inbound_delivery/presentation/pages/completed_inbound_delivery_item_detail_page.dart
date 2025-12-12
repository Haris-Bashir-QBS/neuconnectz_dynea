import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';

class CompletedInboundDeliveryItemDetailPage extends StatelessWidget {
  final InboundDeliveryItemEntity item;

  const CompletedInboundDeliveryItemDetailPage({super.key, required this.item});

  double get _totalBinQuantity =>
      item.binDetails.fold(0.0, (sum, bin) => sum + bin.quantity);

  double get _remainingQuantity =>
      max(0, item.quantity - _totalBinQuantity.toDouble());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.quantity),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppTexts.quantity,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppPalette.darkGreyColor,
              ),
              16.verticalSpace,
              _sectionTitle("Material Details"),
              12.verticalSpace,
              _materialDetailsSection(),
              20.verticalSpace,
              _sectionTitle("Quantity Details"),
              12.verticalSpace,
              _quantityDetailsSection(),
              20.verticalSpace,
              Row(
                children: [
                  _sectionTitle("Bin Details"),
                  Spacer(),
                  _sectionTitle(
                    "Total Count: ${_totalBinQuantity.formatWithCommas}",
                  ),
                ],
              ),
              12.verticalSpace,
              _binDetailsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return CustomText(
      text: title,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _materialDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        spacing: 8.h,
        children: [
          CustomTextFormField(
            label: "Material Name",
            initialValue: item.materialDescription ?? 'N/A',
            readOnly: true,
            isMarquee: true,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          CustomTextFormField(
            label: "Material Number",
            readOnly: true,
            initialValue: item.materialNo ?? 'N/A',
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          if (item.batchNo.isNotEmpty)
            CustomTextFormField(
              label: "Batch",
              readOnly: true,
              initialValue: item.batchNo,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: CustomTextFormField(
          //         label: "Plant",
          //         readOnly: true,
          //         initialValue: item.plant ?? 'N/A',
          //         fillColor: AppPalette.lightGreyColor,
          //         enabled: false,
          //       ),
          //     ),
          //     10.horizontalSpace,
          //     Expanded(
          //       child: CustomTextFormField(
          //         label: "Storage Location",
          //         readOnly: true,
          //         initialValue: item. ?? 'N/A',
          //         fillColor: AppPalette.lightGreyColor,
          //         enabled: false,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _quantityDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              label: "Quantity",
              readOnly: true,
              initialValue: item.quantity.formatWithCommas,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _binDetailsSection() {
    if (item.binDetails.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CustomText(
            text: "No bin details available",
            color: AppPalette.greyColor,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.verticalSpace,
          _binDetailsHeader(),
          10.verticalSpace,
          Column(
            children:
                item.binDetails.map((bin) => _binDetailTile(bin)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _binDetailsHeader() {
    return Row(
      children: [
        CustomText(
          text: "Bin No",
          fontWeight: FontWeight.w500,
          color: AppPalette.greyColor,
          fontSize: 14.sp,
        ),
        Spacer(),
        CustomText(
          text: " Quantity",
          fontWeight: FontWeight.w500,
          color: AppPalette.greyColor,
          fontSize: 14.sp,
        ),
        10.horizontalSpace,
      ],
    );
  }

  Widget _binDetailTile(InboundDeliveryItemBinDetailEntity bin) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text:
                      "${bin.storageType} - ${bin.storageSection} - ${bin.binCode}",
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: _quantityPill(bin.quantity)),
        ],
      ),
    );
  }

  Widget _quantityPill(double quantity) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppPalette.lightGreyColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppPalette.lightGreyColor),
      ),
      child: CustomText(
        text: quantity.formatWithCommas,
        fontWeight: FontWeight.w600,
        fontSize: 13.sp,
      ),
    );
  }
}
