import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'home_section.dart';
import 'home_action_card.dart';

class PhysicalStockCheckSection extends StatelessWidget {
  const PhysicalStockCheckSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: AppTexts.physicalStockCheck,
      actions: [
        HomeActionCardData(
          title: AppTexts.checkStock,
          iconBackgroundColor: AppPalette.d2Color,
          iconColor: Color(0xFF5C6BC0),
          iconPath: AppAssets.stockCheckIcon,
          spanFullWidth: true,
          onTap: () {
            context.pushNamed(
              AppRoutes.documentSelection,
              extra: DocumentSelectionConfigs.stockCheck(),
            );
          },
        ),
      ],
    );
  }
}

