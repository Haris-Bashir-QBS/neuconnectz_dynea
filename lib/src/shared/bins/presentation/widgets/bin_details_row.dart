import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../widgets/custom_text.dart';

class BinDetailRow extends StatelessWidget {
  final BinEntity bin;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onDelete;

  const BinDetailRow({
    super.key,
    required this.bin,
    required this.controller,
    required this.focusNode,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(bin.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 22.sp),
      ),
      onDismissed: (_) => onDelete(),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: CustomText(
              text:
                  "${bin.storageType} - ${bin.storageSection} - ${bin.binCode}",
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
                border: Border.all(color: context.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(6), // smaller radius
              ),
              child: Center(
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 14.sp, height: 2),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                      AppStaticData.quantityFieldMaxLength,
                    ),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty) return newValue;
                      final regex = RegExp(r'^\d*\.?\d{0,3}$');
                      if (regex.hasMatch(newValue.text)) return newValue;
                      return oldValue;
                    }),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
