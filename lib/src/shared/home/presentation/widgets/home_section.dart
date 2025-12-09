import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'home_action_card.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required this.title, required this.actions});

  final String title;
  final List<HomeActionCardData> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.darkBlueColor,
          ),
          12.verticalSpace,
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 12.w;
              final halfWidth = (constraints.maxWidth - spacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children:
                    actions.map((action) {
                      final itemWidth =
                          action.spanFullWidth
                              ? constraints.maxWidth
                              : halfWidth;
                      return SizedBox(
                        width: itemWidth,
                        child: HomeActionCard(data: action),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

