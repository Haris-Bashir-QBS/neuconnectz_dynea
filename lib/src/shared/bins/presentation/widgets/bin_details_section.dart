import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/widgets/bin_details_row.dart';

import '../../../../core/constants/app_palette.dart';
import '../../../../widgets/custom_text.dart';

class BinDetailsSection extends StatelessWidget {
  final List<BinEntity> bins;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index) onDelete;

  const BinDetailsSection({
    super.key,
    required this.bins,
    required this.controllers,
    required this.onDelete,
    required this.focusNodes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomText(
          //   text: "Total Count: ${bins.length}",
          //   fontSize: 14.sp,
          //   fontWeight: FontWeight.w500,
          //   color: AppPalette.darkGreyColor,
          // ),
          15.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomText(
                  text: "Bin No",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.darkGreyColor,
                ),
              ),
              Spacer(),
              CustomText(
                text: "Quantity",
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppPalette.darkGreyColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 10.w),
            ],
          ),
          10.verticalSpace,
          ...List.generate(
            bins.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: BinDetailRow(
                bin: bins[index],
                controller: controllers[index],
                focusNode: focusNodes[index],
                onDelete: () => onDelete(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


