import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/widgets/marquee_text.dart';
import 'custom_text.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final Color? textColor;
  final String? initialValue;
  final bool? enableInteractiveSelection;
  final bool isOutlinedBorder;
  final bool? isMarquee;
  final bool enabled;
  final BorderRadius? borderRadius;
  final bool showClearIcon;
  final Widget? rightActionWidget;
  final Function(String)? onChanged;
  final bool isPassword;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor, prefixIconColor;
  final bool? readOnly;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  const CustomTextFormField({
    super.key,
    this.label,
    this.textColor,
    this.prefixIconColor,
    this.hint,
    this.autofillHints,
    this.isPassword = false,
    this.enableInteractiveSelection,
    this.isOutlinedBorder = true,
    this.initialValue,
    this.fillColor,
    this.focusNode,
    this.onChanged,
    this.isMarquee,
    this.readOnly,
    this.prefixIcon,
    this.suffixIcon,
    this.rightActionWidget,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.showClearIcon = false,

    this.controller,
    this.borderRadius,
    this.borderColor,
    this.enabled = true,
    this.focusedBorderColor,
    this.errorBorderColor,
  });

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;
  late final ValueNotifier<bool> _showClearNotifier;

  @override
  void initState() {
    _showClearNotifier = ValueNotifier(false);

    widget.controller?.addListener(() {
      final isNotEmpty = widget.controller?.text.isNotEmpty ?? false;
      _showClearNotifier.value = isNotEmpty;
    });
    super.initState();
  }

  InputBorder _border(Color? color) {
    final borderSide = BorderSide(
      color: color ?? AppPalette.lightGreyColor,
      width: 1,
    );

    return widget.isOutlinedBorder
        ? OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          borderSide: borderSide,
        )
        : UnderlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          borderSide: borderSide,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label?.isNotEmpty == true) ...[
          CustomText(
            text: widget.label ?? "",
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppPalette.darkGreyColor,
            //  color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(height: 6.h),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                style: TextStyle(
                  color: widget.textColor ?? AppPalette.darkGreyColor,
                  fontSize: 15.sp,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enabled: (widget.enabled),
                controller: widget.controller,
                onTap: widget.onTap,
                focusNode: widget.focusNode,
                autofillHints: widget.autofillHints,
                initialValue: widget.initialValue,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                onChanged: (widget.onChanged),
                readOnly: widget.readOnly ?? false,
                decoration: buildInputDecoration(context),
                enableInteractiveSelection:
                    widget.enableInteractiveSelection ?? true,
                validator: widget.validator,
                inputFormatters: widget.inputFormatters,
                autofocus: false,
              ),
            ),
            if (widget.rightActionWidget != null) widget.rightActionWidget!,
          ],
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hint,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      errorMaxLines: 2,
      fillColor: widget.fillColor ?? Colors.white,
      hintStyle: TextStyle(color: AppPalette.hintColor, fontSize: 15.sp),
      prefixIcon:
          widget.prefixIcon != null
              ? Icon(
                widget.prefixIcon,
                color: widget.prefixIconColor ?? context.primaryColor,
              )
              : null,
      prefix:
          widget.isMarquee == true && widget.readOnly == true
              ? SizedBox(
                height: 20.h,
                width: 1.sw,
                child: Marquee(
                  text: widget.controller?.text ?? widget.initialValue ?? '',
                  style: TextStyle(
                    color: AppPalette.darkGreyColor,
                    fontSize: 15.sp,
                  ),
                  velocity: 30,
                  blankSpace: 60,
                  pauseAfterRound: Duration(milliseconds: 500),
                  startAfter: Duration(milliseconds: 200),
                ),
              )
              : null,
      suffixIcon:
          widget.isPassword
              ? _passwordVisibilityIcon()
              : widget.showClearIcon
              ? _showClearWidget()
              : widget.suffixIcon,

      border: _border(widget.borderColor),
      enabledBorder: _border(widget.borderColor),
      focusedBorder: _border(widget.focusedBorderColor ?? context.primaryColor),
      errorBorder: _border(widget.errorBorderColor ?? Colors.red),
      focusedErrorBorder: _border(widget.errorBorderColor ?? Colors.red),
      disabledBorder: _border(widget.borderColor ?? AppPalette.lightGreyColor),
    );
  }

  Widget _showClearWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showClearNotifier,
      builder: (_, show, __) {
        if (!show) return const SizedBox.shrink();
        return IconButton(
          icon: const Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            widget.controller?.clear();
            _showClearNotifier.value = false;
            if (widget.onChanged != null) {
              widget.onChanged!('');
            }
          },
        );
      },
    );
  }

  Widget _passwordVisibilityIcon() {
    return IconButton(
      icon: Icon(
        _obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: Colors.grey,
      ),
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }

  @override
  void dispose() {
    //  _showClearNotifier.dispose();
    super.dispose();
  }
}
