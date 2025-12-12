import 'package:flutter/material.dart';

class InlineLinearLoader extends StatelessWidget {
  final bool isVisible;
  final double? value;
  final String? label;
  final double minHeight;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? backgroundColor;

  const InlineLinearLoader({
    super.key,
    required this.isVisible,
    this.value,
    this.label,
    this.minHeight = 4.0,
    this.padding = const EdgeInsets.only(bottom: 2.0),
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final progress = LinearProgressIndicator(
      value: value,
      minHeight: minHeight,
      color: color,
      backgroundColor:
          backgroundColor ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
    );

    return Padding(
      padding: padding,
      child: Visibility(
        visible: isVisible,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        replacement: const SizedBox.shrink(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [progress],
        ),
      ),
    );
  }
}


