import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';

class SourceBinMaterialCard extends StatefulWidget {
  final StockEntity item;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onTap;

  const SourceBinMaterialCard({
    super.key,
    required this.item,
    this.onDoubleTap,
    this.onTap,
  });

  @override
  State<SourceBinMaterialCard> createState() => _SourceBinMaterialCardState();
}

class _SourceBinMaterialCardState extends State<SourceBinMaterialCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleDoubleTap() {
    widget.onDoubleTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main content (handles tap and double tap)
          GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: _handleDoubleTap,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppPalette.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppPalette.primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  12.horizontalSpace,
                  // Material info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.material,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppPalette.darkGreyColor,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppPalette.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Available stock
                  Text(
                    item.availableStock.formatWithCommas,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details section (expandable) - also handles double tap
          if (_isExpanded) ...[
            GestureDetector(
              onDoubleTap: _handleDoubleTap,
              child: Column(
                children: [
                  Divider(height: 1, color: Colors.grey.shade200),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Batch No:', item.batch ?? 'N/A'),
                        8.verticalSpace,
                        _buildDetailRow('Storage Type:', item.storageType),
                        8.verticalSpace,
                        _buildDetailRow(
                          'Storage Section:',
                          item.storageLocation,
                        ),
                        8.verticalSpace,
                        _buildDetailRow(
                          'Quant:',
                          item.quant.toInt().toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Action bar
          Container(
            height: 34.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppPalette.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                // Tap to view details section
                Expanded(
                  child: InkWell(
                    onTap: _toggleExpanded,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Text(
                            _isExpanded
                                ? "Tap to hide details"
                                : "Tap to view details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          6.horizontalSpace,
                          Icon(
                            Icons.visibility_outlined,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Vertical divider
                Container(
                  width: 1,
                  height: 34.h,
                  color: Colors.white.withOpacity(0.3),
                ),
                // Double tap to proceed section
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: _handleDoubleTap,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Double tap to proceed",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          6.horizontalSpace,
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppPalette.greyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppPalette.darkGreyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}


