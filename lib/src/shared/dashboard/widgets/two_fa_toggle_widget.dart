import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class TwoFactorAuthenticationWidget extends StatelessWidget {
  final bool is2FAEnabled;
  final bool loading;
  final String? secretKey;
  final VoidCallback onCopyKey, onTapRegenerate;
  final ValueChanged<bool> onToggle2FA;

  const TwoFactorAuthenticationWidget({
    super.key,
    required this.is2FAEnabled,
    this.secretKey,
    required this.onTapRegenerate,
    required this.onCopyKey,
    required this.onToggle2FA,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 20,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(5.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              2.verticalSpace,
              _enableTwoFASwitch(),
              5.verticalSpace,
              _scanQrCodeText(),
              const Divider(),
              if (loading) ...[
                _shimmerQrPlaceholder(),
                _shimmerText(),
                _shimmerCopyContainer(),
              ] else if ((secretKey ?? "").isNotEmpty) ...[
                _qrCodeImage(context),
                _enterManualKeyText(),
                5.verticalSpace,
                _qrCodeViewWidget(context),
              ],
              20.verticalSpace,
              _trustedByLockKeyzWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _enableTwoFASwitch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: AppTexts.twoFactorAuthentication,
            fontWeight: FontWeight.w600,
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(value: is2FAEnabled, onChanged: onToggle2FA),
          ),
        ],
      ),
    );
  }

  Widget _scanQrCodeText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: CustomText(text: AppTexts.scanThisQR, fontWeight: FontWeight.w600),
    );
  }

  Widget _qrCodeImage(BuildContext context) {
    return Center(
      child: QrImageView(
        data: secretKey!,
        version: QrVersions.auto,
        size: 200.0,
        foregroundColor: context.primaryColor,
      ),
    );
  }

  Widget _enterManualKeyText() {
    return Center(
      child: CustomText(
        text: AppTexts.orEnterSecretKeyManually,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _qrCodeViewWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                text: secretKey ?? "",
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: onCopyKey,
              icon: const Icon(Icons.copy, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trustedByLockKeyzWidget(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5.r),
          bottomRight: Radius.circular(5.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: AppTexts.trustedByLockKeyz,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          5.horizontalSpace,
          Image.asset(AppAssets.lockKeyzIcon, width: 50.w, height: 50.h),
        ],
      ),
    );
  }

  Widget _shimmerQrPlaceholder() {
    return Padding(
      padding: EdgeInsets.only(top: 0.h),
      child: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: QrImageView(data: "dummy", size: 200),
        ),
      ),
    );
  }

  Widget _shimmerCopyContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  Widget _shimmerText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 2.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 20.h,
          width: 1.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}


