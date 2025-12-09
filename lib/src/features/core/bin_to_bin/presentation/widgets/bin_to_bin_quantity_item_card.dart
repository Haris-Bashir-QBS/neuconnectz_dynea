import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class BinToBinQuantityItemCard extends StatelessWidget {
  final StockEntity item;
  final bool isSelected;
  final String? error;
  final TextEditingController quantityController;
  final FocusNode quantityFocusNode;
  final ValueChanged<bool> onSelectionChanged;
  final ValueChanged<String> onQuantityChanged;
  final String? Function(String?)? validator;
  final double maxQuantity;

  const BinToBinQuantityItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    this.error,
    required this.quantityController,
    required this.quantityFocusNode,
    required this.onSelectionChanged,
    required this.onQuantityChanged,
    this.validator,
    required this.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          // Checkbox
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: isSelected,
              onChanged: (value) => onSelectionChanged(value ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: AppPalette.primaryColor.withAlpha(150),
            ),
          ),
          6.horizontalSpace,
          // Material info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: item.material ?? 'N/A',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.darkGreyColor,
                ),
                2.verticalSpace,
                CustomText(
                  text: 'Material: ${item.description}',
                  fontSize: 11.sp,
                  color: AppPalette.greyColor,
                ),
              ],
            ),
          ),
          6.horizontalSpace,
          // Proposed Qty (read-only) - Same height as TextFormField
          SizedBox(
            width: 80.w,
            height: 48.h,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(
                text: item.availableStock.formatWithCommas,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppPalette.darkGreyColor,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                filled: true,
                fillColor: AppPalette.lightGreyColor,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          6.horizontalSpace,
          // Act Qty (editable) - Same width and height as Proposed Qty, use validator
          SizedBox(
            width: 80.w,
            height: 48.h,
            child: TextFormField(
              controller: quantityController,
              focusNode: quantityFocusNode,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppPalette.darkGreyColor,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: onQuantityChanged,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  gapPadding: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                  gapPadding: 0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppPalette.primaryColor,
                    width: 1,
                  ),
                  gapPadding: 0,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  gapPadding: 0,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  gapPadding: 0,
                ),
                filled: true,
                fillColor: isSelected ? Colors.white : Colors.grey.shade100,
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: AppPalette.greyColor,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                errorStyle: TextStyle(
                  height: 0.01, // Small non-zero value
                  fontSize: 0.01,
                ), // Hide error text but keep red border
                isCollapsed: true,
                // errorMaxLines: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
