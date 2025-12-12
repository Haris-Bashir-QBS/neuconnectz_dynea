import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/card_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/widgets/item_listing_header_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_list_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/reservation_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/widgets/reservation_card.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/params/reservation_listing_page_params.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/constants/app_texts.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../widgets/custom_appbar.dart';

class ReservationListingPage extends StatelessWidget {
  final ReservationListingPageParams params;

  const ReservationListingPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReservationBloc>(),
      child: _ReservationListingView(params: params),
    );
  }
}

class _ReservationListingView extends StatefulWidget {
  final ReservationListingPageParams params;

  const _ReservationListingView({required this.params});

  @override
  State<_ReservationListingView> createState() =>
      _ReservationListingViewState();
}

class _ReservationListingViewState extends State<_ReservationListingView> {
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
    final params = ReservationListParams(
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      movementType: widget.params.movementType,
      lastCount: 10,
      skipRecords: 0,
      keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
    );

    context.read<ReservationBloc>().add(
      LoadReservationListEvent(params: params, refresh: true),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final pixels = position.pixels;
    final maxScroll = position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<ReservationBloc>().state;

      if (state.listHasMore && !state.listIsLoadingMore) {
        final params = ReservationListParams(
          plant: widget.params.plant,
          storageLocation: widget.params.storageLocation,
          movementType: widget.params.movementType,
          lastCount: 10,
          skipRecords: state.listSkipRecords,
          keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
        );

        context.read<ReservationBloc>().add(
          LoadReservationListEvent(params: params, refresh: false),
        );
      }
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d/M/yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.pickingAgainstReservation),
      body: Column(
        children: [
          CustomSearchField(controller: _searchController),
          SizedBox(height: 8.h),
          Expanded(child: _buildReservationList()),
        ],
      ),
    );
  }

  Widget _buildReservationList() {
    return BlocBuilder<ReservationBloc, ReservationState>(
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
                  itemBuilder: (context, index) => const CardShimmer(),
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
              text: 'No reservations found',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.greyColor,
            ),
          );
        }

        return Column(
          children: [
            ItemListingHeader(
              leftHeading: 'Reservation No',
              rightHeading: 'Receiving Plant/Location',
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _loadInitialData(),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 16.h,
                    left: 16.w,
                    right: 16.w,
                  ),
                  itemCount:
                      state.listItems.length +
                      (state.listIsLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.listItems.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = state.listItems[index];
                    return ReservationCard(
                      item: item,
                      formattedDate: _formatDate(item.requirementsDate),
                      onTap: () => _navigateToReservationItemsPage(item),
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

  void _navigateToReservationItemsPage(ReservationEntity item) async {
    final params = ReservationItemParams(
      reservationNo: item.reservation.toString(),
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      movementType: widget.params.movementType,
      warehouseCode: widget.params.warehouseCode,
      warehouse: widget.params.warehouse,
      lastCount: 10,
      skipRecords: 0,
    );

    await context.pushNamed(AppRoutes.reservationItems, extra: params).then((
      value,
    ) {
      _loadInitialData();
    });
  }
}
