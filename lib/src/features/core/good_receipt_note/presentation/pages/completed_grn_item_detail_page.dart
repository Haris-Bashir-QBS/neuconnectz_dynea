import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';

class CompletedGrnItemDetailPage extends StatelessWidget {
  final GrnItemEntity item;

  const CompletedGrnItemDetailPage({super.key, required this.item});

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
              _sectionTitle("Bin Details"),
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
            initialValue: item.materialDescription,
            readOnly: true,
            isMarquee: true,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          CustomTextFormField(
            label: "Material Number",
            readOnly: true,
            initialValue: item.material,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          if (item.batch.isNotEmpty)
            CustomTextFormField(
              label: "Batch",
              readOnly: true,
              initialValue: item.batch,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: "Plant",
                  readOnly: true,
                  initialValue: item.plant,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomTextFormField(
                  label: "Storage Location",
                  readOnly: true,
                  initialValue: item.storageLocation,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
            ],
          ),
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
              label: "Actual Quantity",
              readOnly: true,
              initialValue:
                  "${item.quantity.formatWithCommas} ${item.baseUOM}",
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomTextFormField(
              label: "Remaining Quantity",
              readOnly: true,
              initialValue:
                  "${_remainingQuantity.formatWithCommas} ${item.baseUOM}",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Total Count: ${_totalBinQuantity.formatWithCommas}",
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: "UOM: ${item.baseUOM}",
                color: AppPalette.greyColor,
                fontSize: 12.sp,
              ),
            ],
          ),
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
      children: const [
        Expanded(
          flex: 4,
          child: CustomText(
            text: "Bin No",
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomText(
            text: "Proposed Qty",
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomText(
            text: "Actual Qty",
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _binDetailTile(GrnItemBinDetailEntity bin) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppPalette.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: bin.binCode,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                  4.verticalSpace,
                  CustomText(
                    text:
                        "${bin.storageType} - ${bin.storageSection}",
                    fontSize: 12.sp,
                    color: AppPalette.darkGreyColor,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: _quantityPill(bin.quantity),
            ),
            Expanded(
              flex: 3,
              child: _quantityPill(bin.quantity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityPill(double quantity) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
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


