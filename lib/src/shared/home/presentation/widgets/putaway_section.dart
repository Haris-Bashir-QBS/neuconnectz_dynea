import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'home_section.dart';
import 'home_action_card.dart';

class PutawaySection extends StatelessWidget {
  const PutawaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: AppTexts.putAway,
      actions: [
        HomeActionCardData(
          title: "Purchase Receipts",
          iconBackgroundColor: AppPalette.d4Color,
          iconColor: AppPalette.lightGreenColor,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.grn(),
            );
          },
        ),
        HomeActionCardData(
          title: "Production Receipts",
          iconBackgroundColor: AppPalette.d3Color,
          iconColor: AppPalette.yellowColor,
          iconPath: AppAssets.pendingIcon,
        ),
        HomeActionCardData(
          title: "${AppTexts.inboundDelivery} (STO)",
          iconBackgroundColor: AppPalette.d1Color,
          iconColor: AppPalette.yellowColor,
          iconPath: AppAssets.pendingIcon,
          spanFullWidth: true,
        ),
      ],
    );
  }
}
