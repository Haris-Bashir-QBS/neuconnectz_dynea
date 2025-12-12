import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/blocs/production_receipt_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/widgets/production_receipt_widget.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/widgets/item_listing_header_shimmer.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/custom_toast.dart';

class ProductionReceiptListingPage extends StatelessWidget {
  final ProductionReceiptListingPageParams params;

  const ProductionReceiptListingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductionReceiptBloc>(),
      child: _ProductionReceiptListingView(params: params),
    );
  }
}

class _ProductionReceiptListingView extends StatefulWidget {
  final ProductionReceiptListingPageParams params;

  const _ProductionReceiptListingView({required this.params});

  @override
  State<_ProductionReceiptListingView> createState() =>
      __ProductionReceiptListingViewState();
}

class __ProductionReceiptListingViewState
    extends State<_ProductionReceiptListingView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  late final ScrollController _scrollController;

  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged);
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
    final params = ProductionReceiptListParams(
      plant: widget.params.plant.code,
      warehouseNumber: widget.params.warehouse.code,
      storageLocation: widget.params.warehouse.storageLocationCode ?? '',
      lastCount: 10,
      skipRecords: 0,
      keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
    );

    context.read<ProductionReceiptBloc>().add(
      LoadProductionReceiptsEvent(params: params, reset: true),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pixels = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<ProductionReceiptBloc>().state;

      if (state is ProductionReceiptHeaderListFetched) {
        if (!state.isHeadersLoading && !state.isLoadingMore && state.hasMore) {
          final params = ProductionReceiptListParams(
            plant: widget.params.plant.code,
            warehouseNumber: widget.params.warehouse.code,
            storageLocation: widget.params.warehouse.storageLocationCode ?? '',
            lastCount: 10,
            skipRecords: state.headers.length,
            keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
          );

          context.read<ProductionReceiptBloc>().add(
            LoadProductionReceiptsEvent(params: params, reset: false),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Putaway Against Production Receipts"),
      body: Column(
        children: [
          CustomSearchField(controller: _searchController),
          SizedBox(height: 8.h),
          Expanded(child: _buildPendingList()),
        ],
      ),
    );
  }

  Widget _buildPendingList() {
    return BlocConsumer<ProductionReceiptBloc, ProductionReceiptState>(
      listener: (context, state) {
        if (state.headersError != null) {
          CustomToast.error(context, state.headersError!);
        }
        if (!state.isHeadersLoading && state.headers.isNotEmpty) {
          context.unfocusFocusScope();
        }
      },
      builder: (context, state) {
        if (state.isHeadersLoading) {
          return Column(
            children: [
              ItemListingHeaderShimmer(),
              10.verticalSpace,
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemBuilder:
                      (context, index) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: AppPalette.greyColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 12.h,
                                    width: 180.w,
                                    color: AppPalette.greyColor.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                  8.verticalSpace,
                                  Container(
                                    height: 12.h,
                                    width: 140.w,
                                    color: AppPalette.greyColor.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            ],
          );
        }

        if (state.headersError != null && state.headers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: state.headersError!,
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

        if (state.headers.isEmpty && !state.isHeadersLoading) {
          return Center(
            child: CustomText(
              text: 'No items found',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.greyColor,
            ),
          );
        }

        if (state.isHeadersLoading &&
            !(state is ProductionReceiptHeaderListFetched &&
                state.isLoadingMore)) {
          // Show shimmer when refreshing (not loading more)
          return Column(
            children: [
              ItemListingHeaderShimmer(),
              10.verticalSpace,
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemBuilder:
                      (context, index) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: AppPalette.greyColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 12.h,
                                    width: 180.w,
                                    color: AppPalette.greyColor.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                  8.verticalSpace,
                                  Container(
                                    height: 12.h,
                                    width: 140.w,
                                    color: AppPalette.greyColor.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            ItemListingHeader(
              leftHeading: "TR Number",
              rightHeading: "Plant/Storage",
            ),
            10.verticalSpace,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _loadInitialData();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemCount:
                      state.headers.length +
                      (state is ProductionReceiptHeaderListFetched &&
                              state.isLoadingMore
                          ? 1
                          : 0),
                  itemBuilder: (context, index) {
                    if (index == state.headers.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppPalette.primaryColor,
                          ),
                        ),
                      );
                    }

                    return ProductionReceiptWidget(
                      item: state.headers[index],
                      onTap: () {
                        _navigateToItemsListingPage(context, state, index);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToItemsListingPage(
    BuildContext context,
    ProductionReceiptState state,
    int index,
  ) async {
    await context
        .pushNamed(
          AppRoutes.productionReceiptItems,
          extra: ProductionReceiptItemsPageParams(
            header: state.headers[index],
            plant: widget.params.plant.code,
            warehouseCode: widget.params.warehouse.code,
            storageLocation: widget.params.warehouse.storageLocationCode ?? '',
          ),
        )
        .then((value) {
          //if (value == true) {
          _loadInitialData();
          // }
        });
  }
}
