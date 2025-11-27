import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/barrels/auth_barrel.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/stock_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/params/stock_query_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/presentation/blocs/stock_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/presentation/params/stock_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/presentation/widgets/stock_card.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

class StockListingPage extends StatelessWidget {
  final StockListingPageParams params;

  const StockListingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StockBloc>(),
      child: _StockListingView(params: params),
    );
  }
}

class _StockListingView extends StatefulWidget {
  final StockListingPageParams params;

  const _StockListingView({required this.params});

  @override
  State<_StockListingView> createState() => _StockListingViewState();
}

class _StockListingViewState extends State<_StockListingView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  StockFilterType _selectedFilter = StockFilterType.all;

  @override
  void initState() {
    super.initState();
    _loadStocks();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _loadStocks() {
    context.read<StockBloc>().add(
      LoadStocksEvent(
        params: StockQueryParams(
          plant: widget.params.plant.code,
          warehouseNumber: widget.params.warehouse.code ?? '',
          filterType: _selectedFilter,
          searchQuery:
              _searchController.text.trim().isEmpty
                  ? null
                  : _searchController.text.trim(),
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<StockBloc>().add(const LoadMoreStocksEvent());
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<StockBloc>().add(
        SearchStockEvent(_searchController.text.trim()),
      );
    });
  }

  String get _searchHint {
    switch (_selectedFilter) {
      case StockFilterType.material:
        return AppTexts.searchMaterial;
      case StockFilterType.storageType:
        return AppTexts.searchStorageType;
      case StockFilterType.storageBin:
        return AppTexts.searchStorageBin;
      case StockFilterType.all:
        return AppTexts.search;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.params.plant;
    final warehouse = widget.params.warehouse;

    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.stockCheck),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text:
                      '${plant.code} • ${warehouse.storageLocationCode ?? ''}',
                  fontSize: 14.sp,
                  color: AppPalette.greyColor,
                ),
                8.verticalSpace,
                _buildFilterRow(),
                12.verticalSpace,
                CustomSearchField(
                  controller: _searchController,
                  hint: _searchHint,
                  onClear: () {
                    _searchController.clear();
                    context.read<StockBloc>().add(const SearchStockEvent(null));
                  },
                ),
              ],
            ),
          ),
          ItemListingHeader(
            leftHeading: AppTexts.material,
            rightHeading: AppTexts.availableStock,
          ),
          8.verticalSpace,
          Expanded(
            child: BlocBuilder<StockBloc, StockState>(
              builder: (context, state) {
                if (state.isLoading && state.items.isEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 6,
                    itemBuilder: (_, __) => StockCardShimmer(),
                  );
                }

                if (state.errorMessage != null && state.items.isEmpty) {
                  return _ErrorView(
                    message: state.errorMessage!,
                    onRetry: _loadStocks,
                  );
                }

                if (state.items.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: AppTexts.noStocksFound,
                      fontSize: 14.sp,
                      color: AppPalette.greyColor,
                    ),
                  );
                }

                final itemCount =
                    state.items.length + (state.isLoadingMore ? 1 : 0);

                return RefreshIndicator(
                  onRefresh: () async => _loadStocks(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = state.items[index];
                      return StockCard(item: item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            StockFilterType.values.map((filter) {
              final isSelected = filter == _selectedFilter;

              final label = switch (filter) {
                StockFilterType.all => AppTexts.all,
                StockFilterType.material => AppTexts.material,
                StockFilterType.storageType => AppTexts.storageType,
                StockFilterType.storageBin => AppTexts.storageBin,
              };

              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                      _searchController.clear();
                    });
                    context.read<StockBloc>().add(
                      ChangeStockFilterEvent(filter),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppPalette.primaryColor.withAlpha(10)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppPalette.primaryColor
                                : AppPalette.greyColor.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color:
                            isSelected
                                ? AppPalette.primaryColor
                                : AppPalette.greyColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: message,
            fontSize: 14.sp,
            color: AppPalette.greyColor,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          ElevatedButton(onPressed: onRetry, child: const Text(AppTexts.retry)),
        ],
      ),
    );
  }
}
