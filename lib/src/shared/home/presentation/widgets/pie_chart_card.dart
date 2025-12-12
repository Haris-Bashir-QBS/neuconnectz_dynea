// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_card.dart';
// import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
//
// class PieChartCard extends StatefulWidget {
//   const PieChartCard({super.key});
//
//   @override
//   State<PieChartCard> createState() => _PieChartCardState();
// }
//
// class _PieChartCardState extends State<PieChartCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   // Sample data - replace with your actual data
//   final List<Map<String, dynamic>> _sections = [
//     {'value': 40.0, 'color': Colors.blue, 'label': '40%'},
//     {'value': 30.0, 'color': Colors.orange, 'label': '30%'},
//     {'value': 20.0, 'color': Colors.green, 'label': '20%'},
//     {'value': 10.0, 'color': Colors.purple, 'label': '10%'},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _animation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//
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
//     final double total = _sections.fold(
//       0.0,
//       (sum, section) => sum + section['value'],
//     );
//     return DashboardCard(
//       title: 'Top Transfer Items',
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: 180,
//             width: 180,
//             child: AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 final double animatedTotal = total * _animation.value;
//                 double accumulated = 0.0;
//                 return PieChart(
//                   PieChartData(
//                     centerSpaceRadius: 35,
//                     sectionsSpace: 2,
//                     startDegreeOffset: -90,
//                     sections:
//                         _sections.map((section) {
//                           final double sectionValue = section['value'];
//                           double valueToShow = 0.0;
//                           if (animatedTotal > accumulated) {
//                             valueToShow = (animatedTotal - accumulated).clamp(
//                               0,
//                               sectionValue,
//                             );
//                           }
//                           accumulated += sectionValue;
//                           return PieChartSectionData(
//                             color: section['color'],
//                             value: valueToShow,
//                             title: section['label'],
//                             radius: 50,
//                             titleStyle: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             titlePositionPercentageOffset: 0.5,
//                           );
//                         }).toList(),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 24),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:
//                 _sections.map((section) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 6),
//                     child: _buildLegend(
//                       section['color'],
//                       'Category ${_sections.indexOf(section) + 1}',
//                     ),
//                   );
//                 }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLegend(Color color, String label) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CircleAvatar(radius: 5, backgroundColor: color),
//         const SizedBox(width: 6),
//         CustomText(text: label, fontSize: 12, color: AppPalette.darkGreyColor),
//       ],
//     );
//   }
// }


