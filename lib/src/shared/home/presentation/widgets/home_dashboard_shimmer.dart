import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/shared/home/presentation/widgets/stock_movement_workflow_shimmer.dart';

import 'bin_to_bin_card_shimmer.dart';
import 'stock_transfer_order_shimmer.dart';

class HomeDashboardShimmer extends StatelessWidget {
  const HomeDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        16.verticalSpace,
        StockTransferOrderShimmer(),
        SizedBox(height: 16),
        BinToBinCardShimmer(),
        SizedBox(height: 16),
        StockMovementWorkflowShimmer(),

        // Add more shimmers for other dashboard components as needed
      ],
    );
  }
}


