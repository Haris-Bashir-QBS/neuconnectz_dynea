import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/asset_paths.dart';

class ClientLogo extends StatelessWidget {
  const ClientLogo({super.key});

  @override
  Widget build(BuildContext context) {
    //return SizedBox(height: 70.h);
    return Image.asset(AppAssets.clientLogo, height: 100.h, width: 240.w);
  }
}
