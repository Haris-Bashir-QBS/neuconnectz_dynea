import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

class GrnListWidget extends StatefulWidget {
  final PlantEntity selectedPlant;
  final WarehouseEntity selectedWarehouse;
  final ScrollController? scrollController;

  const GrnListWidget({
    super.key,
    required this.selectedPlant,
    required this.selectedWarehouse,
    this.scrollController,
  });

  @override
  State<GrnListWidget> createState() => _GrnListWidgetState();
}

class _GrnListWidgetState extends State<GrnListWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  int _selectedTab = 0; // 0 = Pending, 1 = Complete
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged);
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final keyword = _searchController.text.trim();
      if (keyword != _searchKeyword) {
        setState(() {
          _searchKeyword = keyword;
        });
        _loadInitialData();
      }
    });
  }

  void _loadInitialData() {
    if (_selectedTab == 1) {
      // Complete tab - no API yet
      return;
    }

    final params = GrnListParams(
      plant: widget.selectedPlant.code,
      location: widget.selectedWarehouse.storageLocationCode ?? '',
      pageSize: 10,
      pageNumber: 1,
      keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
    );
    context.read<GrnBloc>().add(
      LoadPendingGrnEvent(params: params, refresh: true),
    );
  }

  void _onScroll() {
    if (widget.scrollController == null) return;

    if (widget.scrollController!.position.pixels ==
        widget.scrollController!.position.maxScrollExtent) {
      final state = context.read<GrnBloc>().state;
      if (state is PendingGrnSuccess && 
          state.hasMore && 
          !state.isLoadingMore && 
          _selectedTab == 0) {
        final params = GrnListParams(
          plant: widget.selectedPlant.code,
          location: widget.selectedWarehouse.storageLocationCode ?? '',
          pageSize: 10,
          pageNumber: state.currentPage + 1,
          keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
        );
        context.read<GrnBloc>().add(
          LoadPendingGrnEvent(params: params, refresh: false),
        );
      }
    }
  }

  String _formatDate(String dateStr, String timeStr) {
    try {
      final date = DateTime.parse(dateStr);
      final formattedDate = DateFormat('d/M/yyyy').format(date);
      return '$formattedDate | ${_formatTime(timeStr)}';
    } catch (e) {
      return '$dateStr | $timeStr';
    }
  }

  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute$period';
      }
      return timeStr;
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: AppPalette.greyColor),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),

        // Tabs
        Row(
          children: [
            Expanded(child: _buildTab(0, 'Pending')),
            Expanded(child: _buildTab(1, 'Complete')),
          ],
        ),

        // List Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'List:',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              BlocBuilder<GrnBloc, GrnState>(
                builder: (context, state) {
                  if (_selectedTab == 1) {
                    return CustomText(
                      text: 'Total Count: 0',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    );
                  }
                  if (state is PendingGrnSuccess) {
                    return CustomText(
                      text: 'Total Count: ${state.items.length}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    );
                  }
                  return CustomText(
                    text: 'Total Count: 0',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  );
                },
              ),
            ],
          ),
        ),

        // Column Headers
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'User',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppPalette.greyColor,
              ),
              CustomText(
                text: 'Warehouse Number',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppPalette.greyColor,
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        // List Items
        Expanded(
          child: _selectedTab == 0 ? _buildPendingList() : _buildCompleteList(),
        ),
      ],
    );
  }

  Widget _buildPendingList() {
    return BlocConsumer<GrnBloc, GrnState>(
      listener: (context, state) {
        if (state is PendingGrnFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is PendingGrnLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PendingGrnFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: state.message,
                  fontSize: 16.sp,
                  color: AppPalette.greyColor,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _loadInitialData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is PendingGrnSuccess) {
          if (state.items.isEmpty) {
            return Center(
              child: CustomText(
                text: 'No items found',
                fontSize: 16.sp,
                color: AppPalette.greyColor,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadInitialData();
            },
            child: ListView.builder(
              controller: widget.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final item = state.items[index];
                return _buildListItem(item);
              },
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCompleteList() {
    return Center(
      child: CustomText(
        text: 'Complete list will be available soon',
        fontSize: 16.sp,
        color: AppPalette.greyColor,
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
        if (index == 0) {
          _loadInitialData();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppPalette.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppPalette.primaryColor : AppPalette.greyColor,
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(GrnListItemEntity item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppPalette.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.description, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: item.user,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomText(
                      text: item.warehouseNumber,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // TR Number and Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'TR Number: TR-${item.trNumber}',
                      fontSize: 12.sp,
                      color: AppPalette.greyColor,
                    ),
                    CustomText(
                      text: 'Qty: ${item.numberOfItems.formatWithCommas}',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Details
                _buildDetailRow(
                  'Created On: ${_formatDate(item.createdOn, item.timeOfCreation)}',
                ),
                SizedBox(height: 4.h),
                _buildDetailRow('Supplier: ${item.name}'),
                SizedBox(height: 4.h),
                _buildDetailRow('Material Doc: ${item.materialDocument}'),
                SizedBox(height: 4.h),
                _buildDetailRow('Purchase Order: ${item.purchaseOrder}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String text) {
    return CustomText(
      text: '• $text',
      fontSize: 12.sp,
      color: AppPalette.darkGreyColor,
    );
  }
}
