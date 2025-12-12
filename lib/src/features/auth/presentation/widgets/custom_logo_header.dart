import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';

class CustomLogoHeader extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomLogoHeader({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _backWidget(context),
        Spacer(flex: 2),
        // SizedBox(height: 56.h, width: 1.sw),
        // Image.asset(AppAssets.timePressLogo, height: 56.h, width: 210.w),
        Spacer(flex: 3),
      ],
    );
  }

  Widget _backWidget(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            context.pop();
          },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: context.primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
    );
  }
}


