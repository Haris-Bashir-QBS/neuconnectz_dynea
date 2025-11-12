// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/stat_card.dart';
//
// class AnimatedStatCard extends StatefulWidget {
//   final String iconPath;
//   final String label;
//   final String value;
//   final Color color;
//   final Duration delay;
//
//   const AnimatedStatCard({
//     super.key,
//     required this.iconPath,
//     required this.label,
//     required this.value,
//     required this.color,
//     this.delay = Duration.zero,
//   });
//
//   @override
//   State<AnimatedStatCard> createState() => _AnimatedStatCardState();
// }
//
// class _AnimatedStatCardState extends State<AnimatedStatCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   String _displayValue = "0";
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//
//     // Handle percentage values
//     final isPercentage = widget.value.contains('%');
//     final numericValue = isPercentage
//         ? double.tryParse(widget.value.replaceAll('%', '')) ?? 0
//         : double.tryParse(widget.value) ?? 0;
//
//     _animation = Tween<double>(
//       begin: 0,
//       end: numericValue,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutCubic,
//       ),
//     );
//
//     _controller.addListener(() {
//       setState(() {
//         _displayValue = isPercentage
//             ? "${_animation.value.toStringAsFixed(1)}%"
//             : _animation.value.toStringAsFixed(0);
//       });
//     });
//
//     // Start animation immediately
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StatCard(
//       iconPath: widget.iconPath,
//       label: widget.label,
//       value: _displayValue,
//       color: widget.color,
//     );
//   }
// }
