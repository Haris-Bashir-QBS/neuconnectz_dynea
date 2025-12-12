import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';

import '../../domain/entities/stock_entity.dart';
import '../../domain/params/stock_query_params.dart';

class StockCard extends StatefulWidget {
  final StockEntity item;
  final StockFilterType? priorityField;

  const StockCard({super.key, required this.item, this.priorityField});

  @override
  State<StockCard> createState() => _StockCardState();
}

class _StockCardState extends State<StockCard> {
  bool expanded = false;

  void toggle() {
    setState(() => expanded = !expanded);
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
                /// Main field based on priority filter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMainFieldValue(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_shouldShowDescription()) ...[
                        3.verticalSpace,
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppPalette.greyColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                /// Stock
                Text(
                  item.availableStock.formatWithCommas,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
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
                    children: _buildDetailRows(),
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
                  Icon(
                    expanded ? Icons.visibility_off_rounded : Icons.visibility,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMainFieldValue() {
    final priorityField = widget.priorityField;
    
    if (priorityField == null || priorityField == StockFilterType.all || priorityField == StockFilterType.material) {
      return widget.item.material;
    }
    
    switch (priorityField) {
      case StockFilterType.storageType:
        return widget.item.storageType;
      case StockFilterType.storageBin:
        return widget.item.storageBin;
      case StockFilterType.batch:
        return widget.item.batch ?? "N/A";
      default:
        return widget.item.material;
    }
  }

  bool _shouldShowDescription() {
    final priorityField = widget.priorityField;
    return priorityField == null || 
           priorityField == StockFilterType.all || 
           priorityField == StockFilterType.material;
  }

  List<Widget> _buildDetailRows() {
    final item = widget.item;
    final priorityField = widget.priorityField;

    // Define all detail rows - always include material
    final allRows = [
      _DetailRowData("Material:", item.material),
      _DetailRowData("Quant:", item.quant.toInt().toString()),
      _DetailRowData("Storage Type:", item.storageType),
      _DetailRowData("Storage Section:", item.storageLocation),
      _DetailRowData("Storage Bin:", item.storageBin),
      _DetailRowData("Batch No:", item.batch ?? "N/A"),
    ];

    // Reorder based on priority field - move priority field to first position
    if (priorityField != null && priorityField != StockFilterType.all && priorityField != StockFilterType.material) {
      int? priorityIndex;
      switch (priorityField) {
        case StockFilterType.storageType:
          priorityIndex = 2; // Storage Type (after Material and Quant)
          break;
        case StockFilterType.storageBin:
          priorityIndex = 4; // Storage Bin
          break;
        case StockFilterType.batch:
          priorityIndex = 5; // Batch No
          break;
        default:
          break;
      }

      if (priorityIndex != null && priorityIndex < allRows.length) {
        final priorityRow = allRows.removeAt(priorityIndex);
        allRows.insert(0, priorityRow);
      }
    }

    return allRows.map((row) => _detailRow(row.label, row.value)).toList();
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
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppPalette.greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRowData {
  final String label;
  final String value;

  _DetailRowData(this.label, this.value);
}


