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
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/entities/outbound_delivery_sto_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_event.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_state.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/params/outbound_delivery_sto_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/widgets/outbound_delivery_sto_card.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/router/app_routes.dart';

class OutboundDeliveryStoListingPage extends StatelessWidget {
  final OutboundDeliveryStoListParams params;

  const OutboundDeliveryStoListingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OutboundDeliveryStoBloc>(),
      child: _OutboundDeliveryStoListingView(params: params),
    );
  }
}

class _OutboundDeliveryStoListingView extends StatefulWidget {
  final OutboundDeliveryStoListParams params;

  const _OutboundDeliveryStoListingView({required this.params});

  @override
  State<_OutboundDeliveryStoListingView> createState() =>
      _OutboundDeliveryStoListingViewState();
}

class _OutboundDeliveryStoListingViewState
    extends State<_OutboundDeliveryStoListingView> {
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
    final params = OutboundDeliveryStoListParams(
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      // movementType: widget.params.movementType,
      lastCount: 10,
      skipRecords: 0,
    );

    context.read<OutboundDeliveryStoBloc>().add(
      LoadOutboundDeliveryStoListEvent(params: params, refresh: true),
    );
  }

  void _onScroll() {
    print("sdsadaddsasa");
    if (!_scrollController.hasClients) return;

    final pixels = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<OutboundDeliveryStoBloc>().state;

      if (state.hasMore && !state.loadingMore) {
        final params = OutboundDeliveryStoListParams(
          plant: widget.params.plant,
          storageLocation: widget.params.storageLocation,

          // movementType: widget.params.movementType,
          lastCount: 10,
          skipRecords: state.skipRecords,
        );

        context.read<OutboundDeliveryStoBloc>().add(
          LoadOutboundDeliveryStoListEvent(params: params, refresh: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppTexts.outboundDeliverySto),
      body: Column(
        children: [
          CustomSearchField(controller: _searchController),
          SizedBox(height: 8.h),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<OutboundDeliveryStoBloc, OutboundDeliveryStoState>(
      builder: (context, state) {
        if (state.loading && state.items.isEmpty) {
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

        if (state.error != null && state.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: state.error!,
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

        if (state.items.isEmpty) {
          return Center(
            child: CustomText(
              text: AppTexts.noResultsFound,
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
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemCount: state.items.length + (state.loadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.items.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    return OutboundDeliveryStoCard(
                      item: state.items[index],
                      onTap: () {
                        _navigateToItemsPage(state.items[index]);
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

  void _navigateToItemsPage(OutboundDeliveryStoEntity stoHeader) async {
    await context
        .pushNamed(
          AppRoutes.outboundDeliveryStoItemsListing,
          extra: OutboundDeliveryStoItemsPageParams(
            delivery: stoHeader.delivery,
            plant: widget.params.plant,
            storageLocation: widget.params.storageLocation,
            warehouseCode: widget.params.warehouseCode ?? "",
            //movementType: widget.params.movementType,
          ),
        )
        .then((value) {
          _loadInitialData();
        });
  }
}
