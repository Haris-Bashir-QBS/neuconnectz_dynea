import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';

import '../../../widgets/custom_text.dart';

class NotificationListTile extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;

  const NotificationListTile({
    super.key,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppPalette.lightGreyColor,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Container(
          //     color: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    5.verticalSpace,
                    CustomText(text: description, fontSize: 14),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: timestamp,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


