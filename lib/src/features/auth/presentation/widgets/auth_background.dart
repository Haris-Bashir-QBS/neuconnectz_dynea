import 'package:flutter/material.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';

class BackgroundWrapperWidget extends StatelessWidget {
  final Widget child;
  final bool isLightOpacity;

  const BackgroundWrapperWidget({
    super.key,
    required this.child,
    this.isLightOpacity = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Stack(
          children: [
            _backgroundContainerWidget(context),
            _topCircleWidget(width, context),
            _bottomCircleWidget(width, context),
            child,
          ],
        );
      },
    );
  }

  Widget _backgroundContainerWidget(BuildContext context) {
    return Container(
      color: context.isDarkMode ? Colors.black : Colors.white.withAlpha(240),
    );
  }

  Widget _bottomCircleWidget(double width, BuildContext context) {
    return _blob(
      bottom: -width * 0.3,
      left: -width * 0.3,
      size: width * 0.6,
      color:
          isLightOpacity
              ? context.primaryColorLight.withAlpha(150)
              : context.primaryColorLight,
    );
  }

  Widget _topCircleWidget(double width, BuildContext context) {
    return _blob(
      top: -width * 0.3,
      right: -width * 0.3,
      size: width * 0.7,
      color:
          isLightOpacity
              ? context.primaryColor.withAlpha(150)
              : context.primaryColor,
    );
  }

  Widget _blob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}


