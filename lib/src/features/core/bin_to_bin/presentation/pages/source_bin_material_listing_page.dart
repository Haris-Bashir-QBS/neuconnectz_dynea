import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/mixins/pagination_mixin.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/stock_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/source_bin_material_listing_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/bin_to_bin_quantity_bottom_sheet_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/single_material_quantity_bottom_sheet_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/source_bin_material_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/widgets/single_material_quantity_bottom_sheet.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/widgets/source_bin_material_card.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../widgets/custom_button.dart';

class SourceBinMaterialListingPage extends StatelessWidget {
  final SourceBinMaterialListingPageParams params;

  const SourceBinMaterialListingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SourceBinMaterialListingBloc>(),
      child: _SourceBinMaterialListingView(params: params),
    );
  }
}

class _SourceBinMaterialListingView extends StatefulWidget {
  final SourceBinMaterialListingPageParams params;

  const _SourceBinMaterialListingView({required this.params});

  @override
  State<_SourceBinMaterialListingView> createState() =>
      _SourceBinMaterialListingViewState();
}

class _SourceBinMaterialListingViewState
    extends State<_SourceBinMaterialListingView>
    with PaginationMixin {
  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  void _loadMaterials([String? searchQuery]) {
    context.read<SourceBinMaterialListingBloc>().add(
      LoadSourceBinMaterialsEvent(
        plant: widget.params.plant.code,
        whsCode: widget.params.warehouse.code ?? '',
        storageLocation: widget.params.warehouse.storageLocationCode ?? '',
        storageBin: widget.params.selectedBin.binCode,
        storageType: widget.params.selectedBin.storageType,
        storageSection: widget.params.selectedBin.storageSection,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  void onLoadMore() {
    final state = context.read<SourceBinMaterialListingBloc>().state;
    if (state is SourceBinMaterialListingSuccess &&
        state.hasMore &&
        !state.isLoadingMore) {
      context.read<SourceBinMaterialListingBloc>().add(
        LoadMoreSourceBinMaterialsEvent(
          plant: widget.params.plant.code,
          whsCode: widget.params.warehouse.code ?? '',
          storageLocation: widget.params.warehouse.storageLocationCode ?? '',
          storageBin: widget.params.selectedBin.binCode,
          storageType: widget.params.selectedBin.storageType,
          storageSection: widget.params.selectedBin.storageSection,
          searchQuery:
              searchController.text.trim().isEmpty
                  ? null
                  : searchController.text.trim(),
        ),
      );
    }
  }

  @override
  void onSearchChanged(String query) {
    _loadMaterials(query.isEmpty ? null : query);
  }

  @override
  void onSearchCleared() {
    _loadMaterials(null);
  }

  void _showSingleMaterialQuantityBottomSheet(item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SingleMaterialQuantityBottomSheet(
        params: SingleMaterialQuantityBottomSheetParams(
          plant: widget.params.plant,
          warehouse: widget.params.warehouse,
          sourceBin: widget.params.selectedBin,
          stock: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.params.selectedBin.binCode,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.refresh,
                color: AppPalette.primaryColor,
                size: 20.sp,
              ),
              label: Text(
                AppTexts.changeBin,
                style: TextStyle(
                  color: AppPalette.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomSearchField(
              controller: searchController,
              hint: AppTexts.search,
              onClear: clearSearch,
            ),
          ),

          // List header
          ItemListingHeader(
            leftHeading: AppTexts.material,
            rightHeading: AppTexts.availableStock,
          ),

          10.verticalSpace,
          Expanded(
            child: BlocBuilder<
              SourceBinMaterialListingBloc,
              SourceBinMaterialListingState
            >(
              builder: (context, state) {
                if (state is SourceBinMaterialListingLoading) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 6,
                    itemBuilder: (_, __) => StockCardShimmer(),
                  );
                }

                if (state is SourceBinMaterialListingFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: state.message,
                          fontSize: 14.sp,
                          color: AppPalette.greyColor,
                          textAlign: TextAlign.center,
                        ),
                        12.verticalSpace,
                        ElevatedButton(
                          onPressed: _loadMaterials,
                          child: Text(AppTexts.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SourceBinMaterialListingSuccess) {
                  if (state.items.isEmpty && !state.isLoadingMore) {
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
                    onRefresh: () async => _loadMaterials(),
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (index == state.items.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppPalette.primaryColor,
                              ),
                            ),
                          );
                        }

                        final item = state.items[index];
                        return SourceBinMaterialCard(
                          item: item,
                          onDoubleTap: () {
                            _showSingleMaterialQuantityBottomSheet(item);
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // Proceed All button
          BlocBuilder<
            SourceBinMaterialListingBloc,
            SourceBinMaterialListingState
          >(
            builder: (context, state) {
              final hasItems =
                  state is SourceBinMaterialListingSuccess &&
                  state.items.isNotEmpty;

              if (!hasItems) return const SizedBox.shrink();

              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ).copyWith(bottom: 10),
                  child: CustomButton.bordered(
                    icon: Icons.done_all,
                    text: AppTexts.proceedAll,
                    onPressed: () {
                      context.pushNamed(
                        AppRoutes.binToBinQuantity,
                        extra: BinToBinQuantityBottomSheetParams(
                          plant: widget.params.plant,
                          warehouse: widget.params.warehouse,
                          selectedBin: widget.params.selectedBin,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
