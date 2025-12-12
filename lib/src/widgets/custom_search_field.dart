import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_palette.dart';
import '../core/constants/app_texts.dart' show AppTexts;
import 'custom_text_formfield.dart';

class CustomSearchField extends StatefulWidget {
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? horizontalPadding;
  final double? outerRadius, innerRadius, topPadding, bottomPadding;
  final Function()? onTap, onClear;
  final double? radius;
  final Color? color;

  const CustomSearchField({
    super.key,
    this.hint,
    this.color,
    this.radius = 16,
    required this.controller,
    this.horizontalPadding,
    this.validator,
    this.onChanged,
    this.onTap,
    this.outerRadius,
    this.innerRadius,
    this.topPadding,
    this.bottomPadding,
    this.onClear,
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color ?? Colors.white,
        // borderRadius: BorderRadius.all(
        //   Radius.circular(widget.outerRadius ?? 16),
        // ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding ?? 10.w,
        ).copyWith(
          top: widget.topPadding ?? 10.h,
          bottom: widget.bottomPadding ?? 10.h,
        ),
        child: CustomTextFormField(
          borderRadius: BorderRadius.circular(widget.innerRadius ?? 16),
          hint: widget.hint ?? AppTexts.search,
          prefixIconColor: AppPalette.greyColor,
          controller: widget.controller,
          prefixIcon: Icons.search,
          fillColor: AppPalette.scaffoldBackgroundColor,
          borderColor: Colors.transparent,
          onChanged: widget.onChanged,
          suffixIcon:
              widget.controller.text.isNotEmpty ? clearIconButton() : null,
        ),
      ),
    );
  }

  Widget clearIconButton() {
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        if (widget.onClear != null) {
          widget.onClear!();
        } else {
          widget.controller.clear();
          widget.onChanged?.call("");
        }
      },
    );
  }
}


