import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
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
          iconBackgroundColor: Color(0xFFE91E63),
          iconColor: Colors.white,
          iconPath: AppAssets.binToBinIcon,
          spanFullWidth: true,
          onTap: () {
            context.pushNamed(AppRoutes.binTransferReportListing);
          },
        ),
      ],
    );
  }
}
