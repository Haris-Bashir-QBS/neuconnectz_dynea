import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_event.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_state.dart';
import 'dart:ui';

import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_circular_progress_indicator.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';
import 'package:neuconnectz_dynea/src/widgets/status_dialog.dart';

import '../../../../../core/constants/app_texts.dart';
import '../../../../../widgets/custom_toast.dart';

class BinTransferTransactionDetailsBottomSheet extends StatelessWidget {
  final BinTransferReportEntity report;

  const BinTransferTransactionDetailsBottomSheet({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BinTransferReportBloc, BinTransferReportState>(
      listenWhen: (previous, current) {
        return previous is! DeleteBinRecordLoading &&
                current is DeleteBinRecordLoading ||
            previous is! DeleteBinRecordSuccess &&
                current is DeleteBinRecordSuccess ||
            previous is! DeleteBinRecordFailure &&
                current is DeleteBinRecordFailure;
      },
      listener: (context, state) {
        if (state is DeleteBinRecordSuccess) {
          final message =
              state.apiResponse?.message.isNotEmpty == true
                  ? state.apiResponse!.message
                  : 'Bin transfer deleted successfully';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            try {
              CustomToast.success(context, message);
              Navigator.of(context).pop(true);
            } catch (e) {
              // Context is no longer valid, ignore
            }
          });
        } else if (state is DeleteBinRecordFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            try {
              CustomToast.error(context, state.message);
            } catch (e) {
              // Context is no longer valid, ignore
            }
          });
        }
      },
      child: BlocBuilder<BinTransferReportBloc, BinTransferReportState>(
        builder: (context, state) {
          final isLoading = state is DeleteBinRecordLoading;

          return Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppPalette.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          margin: EdgeInsets.only(bottom: 16.h),
                          decoration: BoxDecoration(
                            color: AppPalette.greyColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      // Title
                      CustomText(
                        text: 'Transaction Details',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.darkGreyColor,
                      ),
                      16.verticalSpace,
                      // Divider
                      Divider(color: AppPalette.lightGreyColor, thickness: 1),
                      16.verticalSpace,
                      _plantAndWarehouseWidget(),
                      16.verticalSpace,
                      _sourceAndDestinationBinWidget(),
                      16.verticalSpace,
                      _totalMaterialsAndTotaCount(),
                      20.verticalSpace,
                      _header(),
                      4.verticalSpace,
                      if (report.materials.isEmpty)
                        _noMaterialsFound()
                      else
                        ...report.materials.map(
                          (material) => _buildMaterialItem(material),
                        ),
                      16.verticalSpace,
                      _editButton(context),
                      20.verticalSpace,
                      _deleteButton(context),
                      SafeArea(child: SizedBox(height: 8.h)),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: CustomCircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  ItemListingHeader _header() {
    return ItemListingHeader(
      leftHeading: AppTexts.material,
      rightHeading: "Total Available Stock",
      horizontalPadding: 0,
    );
  }

  Widget _deleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (report.docNum == null) {
          CustomToast.error(context, 'Document number not available');
          return;
        }

        AnimatedStatusDialog.show(
          context: context,
          isSuccess: false,
          title: AppTexts.deleteBinTransfer,
          message: AppTexts.deleteBinTransferMessage,
          primaryButtonText: AppTexts.delete,
          secondaryButtonText: AppTexts.cancel,
          onPrimaryTap: () {
            context.read<BinTransferReportBloc>().add(
              DeleteBinRecordEvent(docNum: report.docNum!),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.red, size: 20.sp),
            8.horizontalSpace,
            CustomText(
              text: 'Delete Transfer',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  CustomButton _editButton(BuildContext context) {
    return CustomButton.bordered(
      text: 'Edit',
      icon: Icons.edit,
      onPressed: () {
        Navigator.pop(context, 'edit');
      },
      radius: 12.r,
    );
  }

  Padding _noMaterialsFound() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: CustomText(
          text: 'No materials found',
          fontSize: 14.sp,
          color: AppPalette.greyColor,
        ),
      ),
    );
  }

  Container _totalMaterialsAndTotaCount() {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.description,
              label: 'Total Material',
              value: report.totalMaterials.toString(),
            ),
          ),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.inventory,
              label: 'Total Available Stock',
              value: report.totalQuantity.formatWithCommas,
            ),
          ),
        ],
      ),
    );
  }

  Column _sourceAndDestinationBinWidget() {
    return Column(
      children: [
        _buildBinCard(
          icon: Icons.arrow_upward,
          label: 'From Bin',
          binCode:
              '${report.sourceStorageType}-${report.sourceStorageSection}-${report.sourceStorageBin}',
          isFromBin: true,
        ),
        12.verticalSpace,
        _buildBinCard(
          icon: Icons.arrow_downward,
          label: 'To Bin',
          binCode:
              '${report.destinationStorageType}-${report.destinationStorageSection}-${report.destinationStorageBin}',
          isFromBin: false,
        ),
      ],
    );
  }

  Container _plantAndWarehouseWidget() {
    return Container(
      padding: EdgeInsets.all(12.w).copyWith(top: 14.h, bottom: 14.h),
      decoration: BoxDecoration(
        color: AppPalette.primaryColor.withOpacity(0.22),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              icon: Icons.business,
              label: 'Plant',
              value: report.plant,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: _buildInfoCard(
              icon: Icons.warehouse,
              label: 'Warehouse',
              value: report.warehouseNumber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppPalette.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16.sp),
        ),
        8.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.horizontalSpace,
            CustomText(
              text: label,
              fontSize: 12.sp,
              color: AppPalette.primaryColor,
            ),
            2.verticalSpace,
            CustomText(
              text: value,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBinCard({
    required IconData icon,
    required String label,
    required String binCode,
    required bool isFromBin,
  }) {
    final color = isFromBin ? Colors.red : Colors.green;
    final backgroundColor =
        isFromBin ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          8.horizontalSpace,
          CustomText(
            text: '$label:',
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
          4.horizontalSpace,
          CustomText(
            text: binCode,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        //  color: AppPalette.whiteColor,
        // borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppPalette.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppPalette.primaryColor, size: 16.sp),
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: label,
                    fontSize: 12.sp,
                    color: AppPalette.greyColor,
                  ),
                  2.verticalSpace,
                  CustomText(
                    text: value,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.darkGreyColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(BinTransferReportMaterialEntity material) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: AppPalette.primaryColor, size: 20.sp),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: material.material,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.darkGreyColor,
                ),
                4.verticalSpace,
                CustomText(
                  text:
                      'Batch No: ${material.batch.isEmpty ? 'N/A' : material.batch}',
                  fontSize: 12.sp,
                  color: AppPalette.greyColor,
                ),
              ],
            ),
          ),
          CustomText(
            text: material.quantity.formatWithCommas,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.primaryColor,
          ),
        ],
      ),
    );
  }
}
