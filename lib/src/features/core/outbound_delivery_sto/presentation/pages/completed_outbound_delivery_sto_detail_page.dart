import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_item_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';

class CompletedOutboundDeliveryStoDetailPage extends StatelessWidget {
  final OutboundDeliveryStoItemEntity item;

  const CompletedOutboundDeliveryStoDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppTexts.quantity),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              _sectionTitle("Material Details"),
              12.verticalSpace,
              _materialDetailsSection(),
              20.verticalSpace,
              _sectionTitle("Quantity Details"),
              12.verticalSpace,
              _quantityDetailsSection(),
              20.verticalSpace,
              _sectionTitle("Bin & Batch Details"),
              12.verticalSpace,
              _binBatchDetailsSection(),
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
            initialValue: item.itemDescription,
            readOnly: true,
            isMarquee: true,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          CustomTextFormField(
            label: "Material Code",
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: "Delivery Quantity",
                  readOnly: true,
                  initialValue: item.deliveryQuantity.formatWithCommas,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomTextFormField(
                  label: "UOM",
                  readOnly: true,
                  initialValue: item.baseUom,
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

  Widget _binBatchDetailsSection() {
    if (item.binDetails == null || item.binDetails!.isEmpty) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          item.binDetails!.map((bin) {
            return Container(
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bin header
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 15.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.lightGreyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Bin: ${bin.sourceStorageBin}",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              if (bin.sourceStorageSection != null &&
                                  bin.sourceStorageSection!.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: "Bin Name: ${bin.sourceStorageSection}",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppPalette.darkGreyColor,
                                ),
                              ],
                              if (bin.sourceStorageType != null &&
                                  bin.sourceStorageType!.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: "Storage Type: ${bin.sourceStorageType}",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppPalette.darkGreyColor,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // CustomText(
                        //   text: "Total Qty: ${bin.quantity.formatWithCommas}",
                        //   fontSize: 14.sp,
                        //   fontWeight: FontWeight.w500,
                        //   color: AppPalette.darkGreyColor,
                        // ),
                      ],
                    ),
                  ),
                  if (bin.batches != null && bin.batches!.isNotEmpty) ...[
                    SizedBox(height: 15.h),
                    // Batch table headers
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomText(
                            text: "Batch No",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.darkGreyColor,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            text: "Quantity",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.darkGreyColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Batch rows
                    ...bin.batches!.map((batch) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CustomText(
                                text: batch.batchName,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 45.h,
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: AppPalette.lightGreyColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: batch.quantity.formatWithCommas,
                                    fontSize: 14.sp,
                                    color: AppPalette.darkGreyColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ] else ...[
                    SizedBox(height: 10.h),
                    CustomText(
                      text: "No batches available",
                      fontSize: 12.sp,
                      color: AppPalette.greyColor,
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }
}

