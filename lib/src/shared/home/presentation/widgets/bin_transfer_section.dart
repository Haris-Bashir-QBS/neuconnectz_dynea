import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'home_section.dart';
import 'home_action_card.dart';

class BinTransferSection extends StatelessWidget {
  const BinTransferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: AppTexts.binTransfer,
      actions: [
        HomeActionCardData(
          title: AppTexts.binToBinTransfer,
          iconBackgroundColor: Color(0xFFE91E63), // Pink color as shown in image
          iconColor: Colors.white,
          iconPath: AppAssets.purchaseOrderIcon, // Using default icon, can be changed later
          spanFullWidth: true,
          onTap: () {
            context.pushNamed(AppRoutes.binTransferReportListing);
          },
        ),
      ],
    );
  }
}



