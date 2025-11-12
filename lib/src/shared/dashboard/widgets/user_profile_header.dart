import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class UserProfileHeader extends StatelessWidget {
  final String userName;
  final String imagePath;
  const UserProfileHeader({
    super.key,
    required this.userName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.grey[200],
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        CustomText(text: userName, color: Colors.black, fontSize: 18),
      ],
    );
  }
}
