import 'package:flutter/material.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class ClickableTextWidget extends StatefulWidget {
  final String prefixText;
  final String clickableText;
  final VoidCallback onTap;
  final TextStyle? prefixStyle;
  final TextStyle? clickableStyle;
  final Color hoverColor;
  final Color pressedColor;
  final bool showUnderline;

  const ClickableTextWidget({
    super.key,
    required this.prefixText,
    required this.clickableText,
    required this.onTap,
    this.prefixStyle,
    this.clickableStyle,
    this.hoverColor = Colors.redAccent,
    this.pressedColor = Colors.red,
    this.showUnderline = true,
  });

  @override
  State<ClickableTextWidget> createState() => _ClickableTextWithPrefixState();
}

class _ClickableTextWithPrefixState extends State<ClickableTextWidget> {
  bool _isHovering = false;
  bool _isPressing = false;

  @override
  Widget build(BuildContext context) {
    final defaultClickableStyle = TextStyle(
      color:
          _isPressing
              ? widget.pressedColor
              : _isHovering
              ? widget.hoverColor
              : widget.clickableStyle?.color ?? Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      decoration: widget.showUnderline ? TextDecoration.underline : null,
      decorationColor:
          _isPressing
              ? widget.pressedColor
              : _isHovering
              ? widget.hoverColor
              : widget.clickableStyle?.color ?? Colors.red,
      decorationThickness: 1.5,
    );

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: widget.prefixText,
            //style: widget.prefixStyle ?? defaultPrefixStyle,
          ),
          const SizedBox(width: 4),
          MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit:
                (_) => setState(() {
                  _isHovering = false;
                  _isPressing = false;
                }),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressing = true),
              onTapUp: (_) => setState(() => _isPressing = false),
              onTapCancel: () => setState(() => _isPressing = false),
              onTap: widget.onTap,
              child: Text(
                widget.clickableText,
                style: defaultClickableStyle
                    .merge(widget.clickableStyle)
                    .copyWith(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


