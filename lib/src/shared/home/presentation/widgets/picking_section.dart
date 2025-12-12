import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'home_section.dart';
import 'home_action_card.dart';

class PickingSection extends StatelessWidget {
  const PickingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: AppTexts.picking,
      actions: [
        HomeActionCardData(
          title: AppTexts.reservation,
          iconBackgroundColor: AppPalette.d5Color,
          iconColor: AppPalette.primaryColor,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.reservation(),
            );
          },
        ),
        HomeActionCardData(
          title: AppTexts.outboundDeliverySto,
          iconBackgroundColor: AppPalette.d8Color,
          iconColor: Color(0xFF8E5BF7),
          iconPath: AppAssets.pendingIcon,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.outboundDeliverySto(),
            );
          },
        ),
        HomeActionCardData(
          title: AppTexts.outboundDeliverySales,
          iconBackgroundColor: AppPalette.d9Color,
          iconColor: Color(0xFFFF8A65),
          iconPath: AppAssets.grnAddTwoIcon,
          spanFullWidth: true,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.outboundDeliverySales(),
            );
          },
        ),
      ],
    );
  }
}



