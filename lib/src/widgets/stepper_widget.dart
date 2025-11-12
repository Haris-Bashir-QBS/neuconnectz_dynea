import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';

import '../core/constants/app_palette.dart';
import '../core/constants/app_texts.dart';
import 'custom_text.dart';

class StepperWidget extends StatelessWidget {
  final int currentStep;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final String? leftLabel, rightLabel;
  final int leftFlex;
  final int rightFlex;

  const StepperWidget({
    super.key,
    required this.currentStep,
    required this.onLeftTap,
    required this.onRightTap,
    this.leftLabel,
    this.rightLabel,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StepItem(
          title: leftLabel ?? AppTexts.selectWarehouse,
          isActive: currentStep == 0,
          onTap: onLeftTap,
          flex: leftFlex,
        ),
        StepItem(
          title: rightLabel ?? AppTexts.items,
          isActive: currentStep == 1,
          onTap: onRightTap,
          flex: rightFlex,
        ),
      ],
    );
  }
}

class StepItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  final int flex;

  const StepItem({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: title,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: isActive ? context.primaryColor : Colors.grey,
              ),
              7.verticalSpace,
              Container(
                height: isActive ? 3 : 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? context.primaryColor
                          : AppPalette.lightGreyColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
