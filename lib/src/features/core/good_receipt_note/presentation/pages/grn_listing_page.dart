import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/params/grn_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_list_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_widget.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/item_listing_header_shimmer.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/constants/app_texts.dart';
import '../../../../../core/router/app_routes.dart';

class GrnListingPage extends StatefulWidget {
  final PlantEntity selectedPlant;
  final WarehouseEntity selectedWarehouse;
  final ScrollController? scrollController;

  const GrnListingPage({
    super.key,
    required this.selectedPlant,
    required this.selectedWarehouse,
    this.scrollController,
  });

  @override
  State<GrnListingPage> createState() => _GrnListingPageState();
}

class _GrnListingPageState extends State<GrnListingPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

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
        setState(() => _searchKeyword = keyword);
        _loadInitialData();
      }
    });
  }

  void _loadInitialData() {
    final params = GrnListParams(
      plant: widget.selectedPlant.code,
      location: widget.selectedWarehouse.storageLocationCode ?? '',
      lastCount: 10,
      skipRecords: 0,
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

      if (state is PendingGrnSuccess && state.hasMore && !state.isLoadingMore) {
        final params = GrnListParams(
          plant: widget.selectedPlant.code,
          location: widget.selectedWarehouse.storageLocationCode ?? '',
          lastCount: 4,
          skipRecords: state.skipRecords,
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
    } catch (_) {
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
    } catch (_) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchField(controller: _searchController),
        SizedBox(height: 8.h),
        Expanded(child: _buildPendingList()),
      ],
    );
  }

  Widget _buildPendingList() {
    return BlocConsumer<GrnBloc, GrnState>(
      listener: (context, state) {
        if (state is PendingGrnFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is PendingGrnLoading) {
          return Column(
            children: [
              ItemListingHeaderShimmer(),
              10.verticalSpace,
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemBuilder: (context, index) => const GrnListItemShimmer(),
                ),
              ),
            ],
          );
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
                fontWeight: FontWeight.w600,
                color: AppPalette.greyColor,
              ),
            );
          }

          return Column(
            children: [
              ItemListingHeader(
                leftHeading: AppTexts.supplierName,
                rightHeading: AppTexts.poNumber,
              ),
              10.verticalSpace,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _loadInitialData(),
                  child: ListView.builder(
                    controller: widget.scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    itemCount:
                        state.items.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return const GrnListItemShimmer();
                      }

                      return GrnListItemWidget(
                        item: state.items[index],
                        onTap: () {
                          _navigateToGrnItemsListingPage(context, state, index);
                        },
                        formattedDate: _formatDate(
                          state.items[index].createdOn,
                          state.items[index].timeOfCreation,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _navigateToGrnItemsListingPage(
    BuildContext context,
    PendingGrnSuccess state,
    int index,
  ) async {
    await context
        .pushNamed(
          AppRoutes.grnItems,
          extra: GrnItemsPageParams(
            grn: state.items[index],
            plant: widget.selectedPlant.code,
            warehouseCode: widget.selectedWarehouse.code,
            location: widget.selectedWarehouse.storageLocationCode ?? '',
          ),
        )
        .then((value) {
          _loadInitialData();
        });
  }
}
