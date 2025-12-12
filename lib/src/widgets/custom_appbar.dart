import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final Widget? leading;
  final VoidCallback? onTapLeading;
  final double? leadingWidth;
  final List<Widget>? actions;
  final IconData? leadingIconData;
  final Color backgroundColor;
  final double? titleFontSize;
  final TextStyle? titleTextStyle;

  const CustomAppBar({
    super.key,
    this.title,
    this.centerTitle = false,
    this.leading,
    this.actions,
    this.leadingWidth,
    this.leadingIconData,
    this.titleFontSize,
    this.onTapLeading,
    this.backgroundColor = Colors.white,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      leadingWidth: leadingWidth,
      title: CustomText(
        text: title ?? "",
        fontSize: titleFontSize ?? 18.sp,
        color: AppPalette.darkGreyColor,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.start,
      ),
      centerTitle: centerTitle,
      leading:
          leading ??
          IconButton(
            icon: Icon(
              leadingIconData ?? Icons.arrow_back,
              color: AppPalette.darkGreyColor,
            ),
            onPressed: onTapLeading ?? () => Navigator.pop(context),
          ),
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


