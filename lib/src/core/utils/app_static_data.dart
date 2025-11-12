import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/models/stock_transfer_order_model.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';

final class AppStaticData {
  AppStaticData._();

  static const quantityFieldMaxLength = 13;
  static List<StockTransferOrderModel> stockTransferOrders = [
    StockTransferOrderModel(
      id: 'itr_pending',
      title: AppTexts.stockTransferOrderOptionsText[0],
      leadingIconPath: AppAssets.stockTransferOrderIcons[1],
      leadingIconBackgroundColor: AppPalette.stockTransferOrderColors[0],
      description: '',
      onTap: () {},
    ),
    StockTransferOrderModel(
      id: 'it_pending',
      title: AppTexts.stockTransferOrderOptionsText[1],
      leadingIconPath: AppAssets.stockTransferOrderIcons[1],
      leadingIconBackgroundColor: AppPalette.stockTransferOrderColors[1],
      description: '',
      onTap: () {},
    ),
    StockTransferOrderModel(
      id: 'tr_pending',
      title: AppTexts.stockTransferOrderOptionsText[2],
      leadingIconPath: AppAssets.stockTransferOrderIcons[1],
      leadingIconBackgroundColor: AppPalette.stockTransferOrderColors[2],
      description: '',
      onTap: () {},
    ),
    StockTransferOrderModel(
      id: 'itr_integrated',
      title: AppTexts.stockTransferOrderOptionsText[3],
      leadingIconPath: AppAssets.stockTransferOrderIcons[0],
      leadingIconBackgroundColor: AppPalette.stockTransferOrderColors[3],
      description: '',
      onTap: () {},
    ),
    StockTransferOrderModel(
      id: 'it_integrated',
      title: AppTexts.stockTransferOrderOptionsText[4],
      leadingIconPath: AppAssets.stockTransferOrderIcons[0],
      leadingIconBackgroundColor: AppPalette.stockTransferOrderColors[4],
      description: '',
      onTap: () {},
    ),
    StockTransferOrderModel(
      id: 'tr_integrated',
      title: AppTexts.stockTransferOrderOptionsText[5],
      leadingIconPath: AppAssets.stockTransferOrderIcons[0],
      leadingIconBackgroundColor: AppPalette.stockTransferOrderColors[0],
      description: '',
      onTap: () {},
    ),
  ];

  static String dummyNetworkUrl =
      "https://fastly.picsum.photos/id/18/2500/1667.jpg?hmac=JR0Z_jRs9rssQHZJ4b7xKF82kOj8-4Ackq75D_9Wmz8";

  static final bottomBarTitles = [
    AppTexts.home,
    AppTexts.po,
    AppTexts.itr,
    AppTexts.menu,
  ];
  static final bottomBarIcons = [
    AppAssets.homeNewIcon,
    AppAssets.productionOrderIcon,
    AppAssets.stockTransferOrder,
    AppAssets.menuIcon,
  ];

  static final dashboardTitles = [
    AppTexts.dashboard,
    AppTexts.productionOrders,
    AppTexts.itrList,
    AppTexts.menu,
  ];

  static final List<ModuleItem> moduleItems = <ModuleItem>[
    ModuleItem(
      title: AppTexts.putAway,
      iconPath: AppAssets.purchaseOrderIcon,
      subItems: [
        SubModuleItem(
          title: AppTexts.purchaseOrder,
          subtitle: "Create Put-away from Purchase Order",
          iconPath: AppAssets.menuItIcon,
        ),
        // SubModuleItem(
        //   title: AppTexts.inboundDelivery,
        //   subtitle: "Create Putaway from Inbound Delivery",
        //   iconPath: AppAssets.menuItIcon,
        // ),
        // SubModuleItem(
        //   title: AppTexts.reservation,
        //   subtitle: "Create Putaway from Reservation",
        //   iconPath: AppAssets.menuItIcon,
        // ),
        // SubModuleItem(
        //   title: AppTexts.stockTransferOrder,
        //   subtitle: "Create Putaway from Stock Transfer Order",
        //   iconPath: AppAssets.menuItIcon,
        // ),
      ],
      onTap: null,
      onItemTap: (context, item) {
        if (item == AppTexts.purchaseOrder) {
          context.pushNamed(AppRoutes.putAwayFromGr);
        }
      },
    ),
    // ModuleItem(
    //   title: "${AppTexts.sales} & ${AppTexts.delivery}",
    //   iconPath: AppAssets.purchaseOrderIcon,
    //   subItems: [
    //     SubModuleItem(
    //       title: AppTexts.salesOrder,
    //       subtitle: AppTexts.manageAndCreateSalesOrders,
    //       iconPath: AppAssets.menuItIcon,
    //     ),
    //     SubModuleItem(
    //       title: AppTexts.delivery,
    //       subtitle: AppTexts.manageGrns,
    //       iconPath: AppAssets.menuItrIcon,
    //     ),
    //   ],
    //   onTap: null,
    //   onItemTap: (context, item) {
    //     if (item == AppTexts.salesOrder) {
    //       context.pushNamed(AppRoutes.salesOrderListing);
    //     } else if (item == AppTexts.delivery) {
    //       context.pushNamed(AppRoutes.deliveryOrderListing);
    //     }
    //   },
    // ),
    // ModuleItem(
    //   //  title: AppTexts.stockMovement,
    //   title: AppTexts.inventoryMovement,
    //   iconPath: AppAssets.mergeIcon,
    //   subItems: [
    //     SubModuleItem(
    //       title: AppTexts.inventoryTransferRequest,
    //       subtitle: AppTexts.itrSubtitle,
    //       iconPath: AppAssets.stockTransferOrder,
    //     ),
    //     SubModuleItem(
    //       title: AppTexts.inventoryTransfer,
    //       subtitle: AppTexts.itSubtitle,
    //       iconPath: AppAssets.menuItIcon,
    //     ),
    //     SubModuleItem(
    //       title: AppTexts.transferRecieve,
    //       subtitle: AppTexts.trSubtitle,
    //       iconPath: AppAssets.menuTrIcon,
    //       subSubItems: [
    //         SubSubModuleItem(
    //           title: AppTexts.transferRecieve,
    //           subtitle: AppTexts.standardTransferReceive,
    //           iconPath: AppAssets.menuTrIcon,
    //         ),
    //         SubSubModuleItem(
    //           title: AppTexts.productionOrder,
    //           subtitle: AppTexts.transferReceiveForProductionOrders,
    //           iconPath: AppAssets.menuTrIcon,
    //         ),
    //       ],
    //       onSubItemTap: (context, item) {
    //         if (item == AppTexts.transferRecieve) {
    //           context.pushNamed(AppRoutes.createTransferRequest);
    //         } else if (item == AppTexts.productionOrder) {
    //           context.pushNamed(AppRoutes.trListing);
    //         }
    //       },
    //     ),
    //   ],
    //   onTap: null,
    //   onItemTap: (context, item) {
    //     if (item == AppTexts.inventoryTransferRequest) {
    //       context.pushNamed(AppRoutes.itrListing);
    //     } else if (item == AppTexts.inventoryTransfer) {
    //       context.pushNamed(AppRoutes.itListing);
    //     }
    //     // Transfer Receive is now handled by its sub-items
    //   },
    // ),
    // ModuleItem(
    //   title: AppTexts.productionOrderAndGI,
    //   iconPath: AppAssets.productionOrderIcon,
    //   onTap: null,
    //   subItems: [
    //     SubModuleItem(
    //       title: AppTexts.productionOrder,
    //       subtitle: "Manage Production Order",
    //       iconPath: AppAssets.stockTransferOrder,
    //     ),
    //     SubModuleItem(
    //       title: AppTexts.goodIssue,
    //       subtitle: "Manage Good Issue",
    //       iconPath: AppAssets.menuItIcon,
    //     ),
    //   ],
    //   // onTap: (context) {
    //   //   context.pushNamed(
    //   //     AppRoutes.productionOrderListing,
    //   //     extra: ITRParams(isScaffold: true),
    //   //   );
    //   // },
    //   onItemTap: (context, item) {
    //     if (item == AppTexts.productionOrder) {
    //       context.pushNamed(
    //         AppRoutes.productionOrderListing,
    //         extra: ITRParams(isScaffold: true),
    //       );
    //     } else if (item == AppTexts.goodIssue) {
    //       context.pushNamed(AppRoutes.createGoodIssue);
    //     }
    //   },
    // ),
    // ModuleItem(
    //   title: AppTexts.physicalStockCheck,
    //   iconPath: AppAssets.stockCheckIcon,
    //   onTap: (context) {
    //     context.pushNamed(AppRoutes.physicalStockCheck);
    //   },
    //   onItemTap: (context, item) {
    //     context.pushNamed(AppRoutes.physicalStockCheck);
    //   },
    // ),
  ];

  // static final List<StatCardData> statCardRows = [
  //   StatCardData(
  //     iconPath: AppAssets.zigzagThreeIcon,
  //     label: AppTexts.totalTransfers,
  //     value: '',
  //     color: AppPalette.d5Color,
  //   ),
  //   StatCardData(
  //     iconPath: AppAssets.clockIcon,
  //     label: AppTexts.pendingTransfers,
  //     value: '',
  //     color: AppPalette.d6Color,
  //   ),
  // ];

  // static final List<PurchaseOrderCarouselItem> purchaseOrderCarouselItems = [
  //   PurchaseOrderCarouselItem(
  //     backgroundColor: AppPalette.purchaseOrderCarouselItemsColors[2],
  //     iconPath: AppAssets.purchaseOrderIcons[2],
  //     title: 'Pending GRN',
  //     value: '',
  //   ),
  //   PurchaseOrderCarouselItem(
  //     backgroundColor: AppPalette.purchaseOrderCarouselItemsColors[0],
  //     iconPath: AppAssets.purchaseOrderIcons[0],
  //     title: 'Integrated GRN',
  //     value: '',
  //   ),
  //   PurchaseOrderCarouselItem(
  //     backgroundColor: AppPalette.purchaseOrderCarouselItemsColors[3],
  //     iconPath: AppAssets.purchaseOrderIcons[3],
  //     title: 'Total Vendors',
  //     value: '',
  //   ),
  //   PurchaseOrderCarouselItem(
  //     backgroundColor: AppPalette.purchaseOrderCarouselItemsColors[0],
  //     iconPath: AppAssets.purchaseOrderIcons[0],
  //     title: 'Open PO',
  //     value: '',
  //   ),
  //   PurchaseOrderCarouselItem(
  //     backgroundColor: AppPalette.purchaseOrderCarouselItemsColors[1],
  //     iconPath: AppAssets.purchaseOrderIcons[1],
  //     title: 'POs Received',
  //     value: '',
  //   ),
  // ];
}

// ========================== Generic Models =====================
//
// class ProcessTypeOptionModel {
//   final String title, description, iconPath;
//   final VoidCallback onTap;
//   final ProcessType processType;
//
//   ProcessTypeOptionModel({
//     required this.processType,
//     required this.title,
//     required this.description,
//     required this.iconPath,
//     required this.onTap,
//   });
// }
//
// class GenericItem {
//   final String title;
//   final String iconPath;
//   final List<String> items;
//   final void Function(BuildContext, String)? onTap;
//
//   GenericItem({
//     required this.title,
//     required this.iconPath,
//     this.items = const [],
//     this.onTap,
//   });
// }
//
// class StatCardData {
//   final String iconPath;
//   final String label;
//   final String? value;
//   final Color color;
//
//   const StatCardData({
//     required this.iconPath,
//     required this.label,
//     this.value,
//     required this.color,
//   });
// }
//
class SubModuleItem {
  final String title;
  final String subtitle;
  final String? iconPath;
  final List<SubSubModuleItem> subSubItems;
  final void Function(BuildContext, String)? onSubItemTap;

  const SubModuleItem({
    required this.title,
    required this.subtitle,
    this.iconPath,
    this.subSubItems = const [],
    this.onSubItemTap,
  });
}

class SubSubModuleItem {
  final String title;
  final String subtitle;
  final String? iconPath;

  const SubSubModuleItem({
    required this.title,
    required this.subtitle,
    this.iconPath,
  });
}

class ModuleItem {
  final String title;
  final String iconPath;
  final List<SubModuleItem> subItems;
  final void Function(BuildContext, String)? onItemTap;
  final void Function(BuildContext context)? onTap;

  ModuleItem({
    required this.title,
    required this.iconPath,
    this.subItems = const [],
    this.onTap,
    this.onItemTap,
  });
}

//
// class ProductionOrderCarouselItem {
//   final Color backgroundColor;
//   final String iconPath;
//   final String text;
//   final String value;
//
//   ProductionOrderCarouselItem({
//     required this.backgroundColor,
//     required this.iconPath,
//     required this.text,
//     required this.value,
//   });
// }
//
// class PurchaseOrderCarouselItem {
//   final Color backgroundColor;
//   final String iconPath;
//   final String title;
//   final String? value;
//
//   PurchaseOrderCarouselItem({
//     required this.backgroundColor,
//     required this.iconPath,
//     required this.title,
//     this.value,
//   });
//
//   PurchaseOrderCarouselItem copyWith({
//     Color? backgroundColor,
//     String? iconPath,
//     String? title,
//     String? value,
//   }) {
//     return PurchaseOrderCarouselItem(
//       backgroundColor: backgroundColor ?? this.backgroundColor,
//       iconPath: iconPath ?? this.iconPath,
//       title: title ?? this.title,
//       value: value ?? this.value,
//     );
//   }
// }
