// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/barrels/itr_barrel.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_card.dart';
//
// class BarChartCard extends StatefulWidget {
//   const BarChartCard({super.key});
//
//   @override
//   State<BarChartCard> createState() => _BarChartCardState();
// }
//
// class _BarChartCardState extends State<BarChartCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   final List<double> _barValues = [15.0, 22.0, 18.0, 10.0, 25.0, 20.0];
//   final int _highlightedIndex = 4;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _animation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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
//     return DashboardCard(
//       title: AppTexts.topTransferItems,
//       child: Container(
//         decoration: BoxDecoration(
//           //  color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.black.withAlpha(13),
//           //     blurRadius: 10,
//           //     offset: const Offset(0, 2),
//           //   ),
//           // ],
//         ),
//         padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.w),
//         child: SizedBox(
//           height: 200,
//           child: AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: 30,
//                   gridData: const FlGridData(show: false),
//                   borderData: FlBorderData(show: false),
//                   barTouchData: BarTouchData(enabled: false),
//                   titlesData: FlTitlesData(
//                     leftTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 30,
//                         getTitlesWidget: (value, meta) {
//                           if (value.toInt() == _highlightedIndex) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 8.0),
//                               child: Text(
//                                 '\$12,500',
//                                 style: TextStyle(
//                                   color: AppPalette.primaryColor,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 14.sp,
//                                 ),
//                               ),
//                             );
//                           }
//                           return const Text('');
//                         },
//                       ),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget:
//                             (value, meta) => Padding(
//                               padding: EdgeInsets.only(top: 5.0),
//                               child: Text(
//                                 (value.toInt() + 1).toString(),
//                                 style: const TextStyle(
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                         reservedSize: 30,
//                       ),
//                     ),
//                   ),
//                   barGroups: List.generate(_barValues.length, (i) {
//                     final isHighlight = i == _highlightedIndex;
//                     final targetValue = _barValues[i];
//                     final currentValue = targetValue * _animation.value;
//
//                     return BarChartGroupData(
//                       x: i,
//                       barRods: [
//                         BarChartRodData(
//                           toY: currentValue,
//                           color:
//                               isHighlight
//                                   ? AppPalette.primaryColor
//                                   : Colors.grey.shade300,
//                           width: 45,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


