// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
// import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
// import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
// import 'package:neuconnectz_dynea/src/features/core/dashboard/widgets/user_profile_header.dart';
// import 'package:neuconnectz_dynea/src/widgets/custom_icon_button.dart';

// import 'expandable_list_tile.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: AppPalette.scaffoldBackgroundColor,
//       child: Stack(
//         children: [
//           // CustomPaint(
//           //   painter: IrregularBackgroundPainter(
//           //     primaryColor: context.primaryColor,
//           //     primaryLightColor: context.primaryColorLight,
//           //   ),
//           //   size: Size.infinite,
//           // ),
//           Column(
//             children: [
//               const DrawerHeader(
//                 child: UserProfileHeader(userName: "M. Sheroz", imagePath: ""),
//               ),
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     ExpandableListTile(
//                       title: AppTexts.administration,
//                       items: [
//                         AppTexts.user,
//                         AppTexts.configuration,
//                         AppTexts.synchronization,
//                       ],
//                       onItemTap: (String item) {
//                         if (item == AppTexts.user) {
//                           context.pushNamed(AppRoutes.userListing);
//                         }
//                         if (item == AppTexts.synchronization) {
//                           context.pushNamed(AppRoutes.synchronization);
//                         }
//                       },
//                     ),
//                     _divider(),
//                     ExpandableListTile(
//                       title: AppTexts.inventory,
//                       items: [
//                         AppTexts.inventoryTransferRequest,
//                         AppTexts.inventoryTransfer,
//                         AppTexts.inventoryCount,
//                       ],
//                       onItemTap: (String item) {
//                         if (item == AppTexts.inventoryTransferRequest) {
//                           context.pushNamed(AppRoutes.inventoryTransferPage);
//                         }
//                         // if (item == AppTexts.inventoryTransfer) {
//                         //   context.pushNamed(AppRoutes.inventoryTransfer);
//                         // }
//                       },
//                     ),
//                     _divider(),

//                     ExpandableListTile(
//                       title: AppTexts.banking,
//                       items: [
//                         AppTexts.outgoingPayment,
//                         AppTexts.incomingPayment,
//                       ],
//                     ),
//                     _divider(),
//                     ExpandableListTile(
//                       title: AppTexts.sales,
//                       items: [AppTexts.salesOrder, AppTexts.delivery_order],
//                     ),
//                     _divider(),
//                     ExpandableListTile(
//                       title: AppTexts.purchase,
//                       items: [AppTexts.purchaseOrder, AppTexts.goodReceiptNote],
//                     ),
//                     _divider(),
//                     ExpandableListTile(
//                       title: AppTexts.reports,
//                       items: [
//                         AppTexts.openDocument,
//                         AppTexts.itrPending,
//                         AppTexts.varianceReport,
//                       ],
//                     ),
//                     _divider(),
//                     CustomIconButton(
//                       icon: Icon(Icons.settings, color: Colors.black),
//                       text: AppTexts.settings,
//                       onTap: () {
//                         context.pushNamed(AppRoutes.settings);
//                       },
//                     ),
//                     CustomIconButton(
//                       onTap: () {
//                         context.goNamed(AppRoutes.login);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Divider _divider() =>
//       Divider(color: Colors.white.withAlpha(140), thickness: 0.4);
// }
