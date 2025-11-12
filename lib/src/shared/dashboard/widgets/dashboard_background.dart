// import 'package:flutter/material.dart';

// class IrregularBackgroundPainter extends CustomPainter {
//   final Color primaryColor;
//   final Color primaryLightColor;

//   IrregularBackgroundPainter({
//     required this.primaryColor,
//     required this.primaryLightColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..style = PaintingStyle.fill;

//     // 🎨 Full background gradient to fill any empty areas
//     final Rect fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
//     paint.shader = LinearGradient(
//       colors: [
//         primaryLightColor.withOpacity(0.6),
//         primaryColor.withOpacity(0.6),
//       ],
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     ).createShader(fullRect);
//     canvas.drawRect(fullRect, paint);

//     // 🎨 First irregular shape (Bottom Layer)
//     Path path1 = Path();
//     path1.moveTo(0, size.height * 0.65);
//     path1.cubicTo(
//       size.width * 0.3,
//       size.height * 0.75,
//       size.width * 0.7,
//       size.height * 0.55,
//       size.width,
//       size.height * 0.7,
//     );
//     path1.lineTo(size.width, size.height);
//     path1.lineTo(0, size.height);
//     path1.close();

//     paint.shader = LinearGradient(
//       colors: [primaryColor, primaryLightColor],
//       begin: Alignment.bottomLeft,
//       end: Alignment.topRight,
//     ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//     canvas.drawPath(path1, paint);

//     // 🎨 Second irregular shape (Middle Layer)
//     Path path2 = Path();
//     path2.moveTo(0, size.height * 0.55);
//     path2.cubicTo(
//       size.width * 0.2,
//       size.height * 0.45,
//       size.width * 0.6,
//       size.height * 0.5,
//       size.width,
//       size.height * 0.6,
//     );
//     path2.lineTo(size.width, size.height * 0.7);
//     path2.lineTo(0, size.height * 0.8);
//     path2.close();

//     paint.shader = LinearGradient(
//       colors: [
//         primaryLightColor.withOpacity(0.8),
//         primaryColor.withOpacity(0.9),
//       ],
//       stops: [0.3, 0.7],
//       begin: Alignment.centerLeft,
//       end: Alignment.centerRight,
//     ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//     canvas.drawPath(path2, paint);

//     // 🎨 Third irregular shape (Top Layer)
//     Path path3 = Path();
//     path3.moveTo(0, size.height * 0.35);
//     path3.cubicTo(
//       size.width * 0.2,
//       size.height * 0.15,
//       size.width * 0.7,
//       size.height * 0.25,
//       size.width,
//       size.height * 0.35,
//     );
//     path3.lineTo(size.width, 0);
//     path3.lineTo(0, 0);
//     path3.close();

//     paint.shader = LinearGradient(
//       colors: [primaryLightColor, primaryColor],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//     canvas.drawPath(path3, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
