// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:neuconnectz_dynea/src/core/barrels/itr_barrel.dart';
// import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
//
// class StockSliderWidget extends StatefulWidget {
//   const StockSliderWidget({super.key});
//
//   @override
//   State<StockSliderWidget> createState() => _StockSliderWidgetState();
// }
//
// class _StockSliderWidgetState extends State<StockSliderWidget> {
//   final CarouselSliderController _carouselController =
//       CarouselSliderController();
//   int _current = 0;
//
//   late final List<_SliderItem> _items;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _items = [
//       _SliderItem(
//         icon: AppAssets.sliderCheck,
//         title: 'Physical Stock Check',
//         description: 'Verify stock on hand efficiently with real-time updates.',
//         buttonText: 'Check Stock',
//         onTap: (context) => context.pushNamed(AppRoutes.physicalStockCheck),
//       ),
//       _SliderItem(
//         icon: AppAssets.sliderCheck,
//         title: 'Production Order',
//         description: 'Track and manage all production activities.',
//         buttonText: 'Check Production Order',
//         onTap:
//             (context) => context.pushNamed(
//               AppRoutes.productionOrderListing,
//               extra: ITRParams(isScaffold: true),
//             ),
//       ),
//       _SliderItem(
//         icon: AppAssets.sliderCheck,
//         title: 'Purchase Order',
//         description: 'Analyze purchases and manage procurement effortlessly.',
//         buttonText: 'Check Purchase Order',
//         onTap: (context) => context.pushNamed(AppRoutes.pendingGRNs),
//       ),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 142.h,
//           child: CarouselSlider.builder(
//             itemCount: _items.length,
//             carouselController: _carouselController,
//             itemBuilder: (context, index, realIndex) {
//               final item = _items[index];
//               return Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10.w),
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16.r),
//                   boxShadow: [
//                     // BoxShadow(
//                     //   color: Colors.black12,
//                     //   blurRadius: 6,
//                     //   offset: Offset(0, 2),
//                     // ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: AppPalette.primaryColor.withAlpha(30),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Image.asset(
//                             item.icon,
//                             width: 30.w,
//                             height: 30.w,
//                             color: Colors.blue,
//                           ),
//                         ),
//                         SizedBox(width: 15.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CustomText(
//                                 text: item.title,
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               4.verticalSpace,
//                               CustomText(
//                                 text: item.description,
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: AppPalette.greyColor,
//                                 maxLines: 3,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     10.verticalSpace,
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: CustomButton(
//                         onPressed: () => item.onTap(context),
//                         text: item.buttonText,
//                         fontSize: 12.sp,
//                         height: 30.h,
//                         //   width: 160.w,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             options: CarouselOptions(
//               height: double.infinity,
//               autoPlay: false,
//               autoPlayInterval: const Duration(seconds: 8),
//               viewportFraction: 1.0,
//               onPageChanged: (index, reason) {
//                 setState(() => _current = index);
//               },
//             ),
//           ),
//         ),
//         12.verticalSpace,
//         AnimatedSmoothIndicator(
//           activeIndex: _current,
//           count: _items.length,
//           effect: WormEffect(
//             dotHeight: 8,
//             dotWidth: 8,
//             activeDotColor: AppPalette.primaryColor,
//             dotColor: Colors.grey.shade400,
//           ),
//           onDotClicked: (index) {
//             _carouselController.animateToPage(index);
//           },
//         ),
//       ],
//     );
//   }
// }
//
// class _SliderItem {
//   final String icon;
//   final String title;
//   final String description;
//   final String buttonText;
//   final void Function(BuildContext context) onTap;
//
//   _SliderItem({
//     required this.icon,
//     required this.title,
//     required this.description,
//     required this.buttonText,
//     required this.onTap,
//   });
// }


