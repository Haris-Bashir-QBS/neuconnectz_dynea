import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';

import '../../domain/entities/stock_entity.dart';

class StockCard extends StatefulWidget {
  final StockEntity item;

  const StockCard({super.key, required this.item});

  @override
  State<StockCard> createState() => _StockCardState();
}

class _StockCardState extends State<StockCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  late AnimationController _controller;
  late Animation<double> rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    rotateAnim = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  void toggle() {
    setState(() => expanded = !expanded);
    expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          /// ===== TOP SECTION =====
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Circle Number
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.quant.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                ),

                12.horizontalSpace,

                /// Material name + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.material,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      3.verticalSpace,
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

                /// Stock
                Text(
                  item.availableStock.formatWithCommas,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: item.availableStock < 0 ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          /// ===== DETAILS SECTION =====
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Container(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: Colors.grey.shade200),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailRow("Storage Type:", item.storageType),
                      _detailRow("Storage Section:", item.storageLocation),
                      _detailRow("Storage Bin:", item.storageBin),
                      _detailRow("Batch No:", item.batch ?? "N/A"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ===== BUTTON ALWAYS AT BOTTOM =====
          InkWell(
            onTap: toggle,
            child: Container(
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppPalette.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    expanded ? "Hide Details" : "View Details",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                  6.horizontalSpace,
                  RotationTransition(
                    turns: rotateAnim,
                    child: const Icon(Icons.expand_more, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          6.horizontalSpace,
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
