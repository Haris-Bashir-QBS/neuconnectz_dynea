import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_list_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/item_listing_header_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/entities/outbound_delivery_sales_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/domain/params/outbound_delivery_sales_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/blocs/outbound_delivery_sales_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/params/outbound_delivery_sales_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sales/presentation/widgets/outbound_delivery_sales_card.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/router/app_routes.dart';

class OutboundDeliverySalesListingPage extends StatelessWidget {
  final OutboundDeliverySalesListingPageParams params;

  const OutboundDeliverySalesListingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OutboundDeliverySalesBloc>(),
      child: _OutboundDeliverySalesListingView(params: params),
    );
  }
}

class _OutboundDeliverySalesListingView extends StatefulWidget {
  final OutboundDeliverySalesListingPageParams params;

  const _OutboundDeliverySalesListingView({required this.params});

  @override
  State<_OutboundDeliverySalesListingView> createState() =>
      _OutboundDeliverySalesListingViewState();
}

class _OutboundDeliverySalesListingViewState
    extends State<_OutboundDeliverySalesListingView> {
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
    final params = OutboundDeliverySalesListParams(
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      deliveryNo: _searchKeyword.isEmpty ? null : _searchKeyword,
      lastCount: 10,
      skipRecords: 0,
    );

    context.read<OutboundDeliverySalesBloc>().add(
      LoadOutboundDeliverySalesListEvent(params: params, refresh: true),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pixels = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<OutboundDeliverySalesBloc>().state;

      if (state.listHasMore && !state.listIsLoadingMore) {
        final params = OutboundDeliverySalesListParams(
          plant: widget.params.plant,
          storageLocation: widget.params.storageLocation,
          deliveryNo: _searchKeyword.isEmpty ? null : _searchKeyword,
          lastCount: 10,
          skipRecords: state.listSkipRecords,
        );

        context.read<OutboundDeliverySalesBloc>().add(
          LoadOutboundDeliverySalesListEvent(params: params, refresh: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.outboundDeliverySales),
      body: Column(
        children: [
          CustomSearchField(controller: _searchController),
          SizedBox(height: 8.h),
          Expanded(child: _buildSalesOrderList()),
        ],
      ),
    );
  }

  Widget _buildSalesOrderList() {
    return BlocBuilder<OutboundDeliverySalesBloc, OutboundDeliverySalesState>(
      builder: (context, state) {
        if (state.listLoading && state.listItems.isEmpty) {
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

        if (state.listError != null && state.listItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: state.listError!,
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

        if (state.listItems.isEmpty) {
          return Center(
            child: CustomText(
              text: 'No sales orders found',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.greyColor,
            ),
          );
        }

        return Column(
          children: [
            ItemListingHeader(
              leftHeading: 'Delivery No',
              rightHeading: 'Plant/Location',
            ),
            10.verticalSpace,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _loadInitialData(),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount:
                      state.listItems.length +
                      (state.listIsLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.listItems.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final item = state.listItems[index];
                    return OutboundDeliverySalesCard(
                      item: item,
                      onTap: () => _navigateToSalesOrderItemsPage(item),
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

  void _navigateToSalesOrderItemsPage(OutboundDeliverySalesEntity item) async {
    final params = OutboundDeliverySalesItemsPageParams(
      delivery: item.delivery,
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      warehouseCode: widget.params.warehouseCode,
      warehouse: widget.params.warehouse,
    );

    await context.pushNamed(AppRoutes.outboundDeliverySalesItems, extra: params).then((
      value,
    ) {
      _loadInitialData();
    });
  }
}

