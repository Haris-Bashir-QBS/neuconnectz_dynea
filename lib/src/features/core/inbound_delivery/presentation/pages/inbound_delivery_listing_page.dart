import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/blocs/inbound_delivery_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/widgets/inbound_delivery_list_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/widgets/inbound_delivery_row_widget.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/widgets/item_listing_header_shimmer.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/custom_toast.dart';

class InboundDeliveryListingPage extends StatelessWidget {
  final InboundDeliveryListingPageParams params;

  const InboundDeliveryListingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InboundDeliveryBloc>(),
      child: _InboundDeliveryListingView(params: params),
    );
  }
}

class _InboundDeliveryListingView extends StatefulWidget {
  final InboundDeliveryListingPageParams params;

  const _InboundDeliveryListingView({required this.params});

  @override
  State<_InboundDeliveryListingView> createState() =>
      __InboundDeliveryListingViewState();
}

class __InboundDeliveryListingViewState
    extends State<_InboundDeliveryListingView> {
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
    final params = InboundDeliveryListParams(
      plant: widget.params.plant.code,
      storageLocation: widget.params.warehouse.storageLocationCode ?? '',
      lastCount: 10,
      skipRecords: 0,
      keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
    );

    context.read<InboundDeliveryBloc>().add(
      LoadPendingInboundDeliveryEvent(params: params, refresh: true),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pixels = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<InboundDeliveryBloc>().state;

      if (state is InboundDeliveryHeaderListFetched &&
          state.hasMore &&
          !state.isLoadingMore) {
        final params = InboundDeliveryListParams(
          plant: widget.params.plant.code,
          storageLocation: widget.params.warehouse.storageLocationCode ?? '',
          lastCount: 10,
          skipRecords: state.skipRecords,
          keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
        );

        context.read<InboundDeliveryBloc>().add(
          LoadPendingInboundDeliveryEvent(params: params, refresh: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Inbound Delivery"),
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
    return BlocConsumer<InboundDeliveryBloc, InboundDeliveryState>(
      listener: (context, state) {
        if (state is InboundDeliveryHeaderListFetchFailure) {
          CustomToast.error(context, state.message);
        }
        if (state is InboundDeliveryHeaderListFetched) {
          context.unfocusFocusScope();
        }
      },
      builder: (context, state) {
        if (state is InboundDeliveryHeaderListLoading) {
          return Column(
            children: [
              ItemListingHeaderShimmer(),
              10.verticalSpace,
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemBuilder:
                      (context, index) =>
                          const InboundDeliveryListItemShimmer(),
                ),
              ),
            ],
          );
        }

        if (state is InboundDeliveryHeaderListFetchFailure) {
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

        if (state is InboundDeliveryHeaderListFetched) {
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
                leftHeading: "STO Number",
                rightHeading: "Outbound Delivery",
              ),
              10.verticalSpace,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _loadInitialData(),
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    itemCount:
                        state.items.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return InboundDeliveryListItemWidget(
                        item: state.items[index],
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
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _navigateToItemsListingPage(
    BuildContext context,
    InboundDeliveryHeaderListFetched state,
    int index,
  ) async {
    await context
        .pushNamed(
          AppRoutes.inboundDeliveryItems,
          extra: InboundDeliveryItemsPageParams(
            inboundDelivery: state.items[index],
            plant: widget.params.plant.code,
            warehouseCode: widget.params.warehouse.code,
            location: widget.params.warehouse.storageLocationCode ?? '',
          ),
        )
        .then((value) {
          _loadInitialData();
        });
  }
}
