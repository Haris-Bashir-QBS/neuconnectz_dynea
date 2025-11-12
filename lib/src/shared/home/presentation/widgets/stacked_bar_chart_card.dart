// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:neuconnectz_dynea/src/core/barrels/itr_barrel.dart';
// import 'package:neuconnectz_dynea/src/features/core/home/presentation/widgets/dashboard_card.dart';
//
// class StackedBarChartCard extends StatefulWidget {
//   const StackedBarChartCard({super.key});
//
//   @override
//   State<StackedBarChartCard> createState() => _StackedBarChartCardState();
// }
//
// class _StackedBarChartCardState extends State<StackedBarChartCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   // Sample data - replace with your actual data
//   final List<List<double>> _stackValues = [
//     [2.0, 3.5, 4.5],
//     [1.5, 2.5, 3.0],
//     [4.0, 2.0, 5.0],
//     [3.0, 4.0, 2.0],
//     [5.0, 1.0, 1.5],
//     [2.5, 3.0, 4.0],
//     [1.0, 4.5, 3.5],
//     [4.2, 3.8, 1.0],
//     [2.0, 2.0, 2.0],
//     [3.5, 4.5, 2.5],
//     [1.8, 2.2, 5.0],
//     [4.0, 4.0, 1.0],
//   ];
//
//   final List<Color> _stackColors = [
//     AppPalette.primaryColor,
//     AppPalette.primaryColor.withOpacity(0.7),
//     AppPalette.primaryColor.withOpacity(0.4),
//   ];
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
//       child: SizedBox(
//         height: 200,
//         child: AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return BarChart(
//               BarChartData(
//                 maxY: 12,
//                 gridData: const FlGridData(show: false),
//                 borderData: FlBorderData(show: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(),
//                   rightTitles: const AxisTitles(),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       getTitlesWidget: (value, meta) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             (value.toInt() + 1).toString(),
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 barGroups: List.generate(12, (i) {
//                   final stack = _stackValues[i];
//                   double currentBottom = 0;
//
//                   return BarChartGroupData(
//                     x: i,
//                     barRods: [
//                       BarChartRodData(
//                         width: 17,
//                         toY: stack.reduce((a, b) => a + b) * _animation.value,
//                         rodStackItems: [
//                           BarChartRodStackItem(
//                             currentBottom,
//                             (currentBottom += stack[0] * _animation.value),
//                             _stackColors[0],
//                           ),
//                           BarChartRodStackItem(
//                             currentBottom,
//                             (currentBottom += stack[1] * _animation.value),
//                             _stackColors[1],
//                           ),
//                           BarChartRodStackItem(
//                             currentBottom,
//                             (currentBottom += stack[2] * _animation.value),
//                             _stackColors[2],
//                           ),
//                         ],
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(6),
//                           topRight: Radius.circular(6),
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
