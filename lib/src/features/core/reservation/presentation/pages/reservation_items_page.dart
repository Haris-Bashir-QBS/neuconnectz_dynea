import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/card_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/params/reservation_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/reservation_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/params/reservation_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/widgets/reservation_item_card.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/router/app_routes.dart';

class ReservationItemsPage extends StatelessWidget {
  final ReservationItemParams params;

  const ReservationItemsPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReservationBloc>(),
      child: _ReservationItemsView(params: params),
    );
  }
}

class _ReservationItemsView extends StatefulWidget {
  final ReservationItemParams params;

  const _ReservationItemsView({required this.params});

  @override
  State<_ReservationItemsView> createState() => _ReservationItemsViewState();
}

class _ReservationItemsViewState extends State<_ReservationItemsView> {
  final ScrollController _pendingScrollController = ScrollController();
  final ScrollController _completedScrollController = ScrollController();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadPending(refresh: true);
    _loadCompleted(refresh: true);
    _pendingScrollController.addListener(_onPendingScroll);
    _completedScrollController.addListener(_onCompletedScroll);
  }

  @override
  void dispose() {
    _pendingScrollController.dispose();
    _completedScrollController.dispose();
    super.dispose();
  }

  void _loadPending({required bool refresh}) {
    context.read<ReservationBloc>().add(
      LoadReservationItemsEvent(params: widget.params, refresh: refresh),
    );
  }

  void _loadCompleted({required bool refresh}) {
    context.read<ReservationBloc>().add(
      LoadCompletedReservationItemsEvent(
        params: widget.params,
        refresh: refresh,
      ),
    );
  }

  void _onPendingScroll() {
    if (!_pendingScrollController.hasClients) return;

    final pixels = _pendingScrollController.position.pixels;
    final maxScroll = _pendingScrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final bloc = context.read<ReservationBloc>();
      if (bloc.state.pendingHasMore && !bloc.state.pendingIsLoadingMore) {
        _loadPending(refresh: false);
      }
    }
  }

  void _onCompletedScroll() {
    if (!_completedScrollController.hasClients) return;

    final pixels = _completedScrollController.position.pixels;
    final maxScroll = _completedScrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final bloc = context.read<ReservationBloc>();
      if (bloc.state.completedHasMore && !bloc.state.completedIsLoadingMore) {
        _loadCompleted(refresh: false);
      }
    }
  }

  Future<void> _showQuantityBottomSheet(item) async {
    final result = await context.pushNamed<bool>(
      AppRoutes.reservationQuantity,
      extra: ReservationQuantityPageParams(
        item: item,
        plant: widget.params.plant,
        storageLocation: widget.params.storageLocation,
        movementType: widget.params.movementType,
        warehouseCode: widget.params.warehouseCode,
        warehouse: widget.params.warehouse,
      ),
    );

    if (!mounted) return;
    if (result == true) {
      _loadPending(refresh: true);
    }
  }

  Future<void> _showCompletedDetails(ReservationItemEntity item) async {
    await context.pushNamed(
      AppRoutes.completedReservationItemDetail,
      extra: item,
    );
    if (!mounted) return;
    _loadCompleted(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.pickingAgainstReservation),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTab(0, AppTexts.pending)),
              Expanded(child: _buildTab(1, AppTexts.completed)),
            ],
          ),
          10.verticalSpace,
          ItemListingHeader(
            leftHeading: AppTexts.materialName,
            rightHeading: AppTexts.quantity,
          ),
          SizedBox(height: 8.h),
          Expanded(
            child:
                _selectedTab == 0 ? _buildPendingList() : _buildCompletedList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        if (_selectedTab != index) {
          setState(() {
            _selectedTab = index;
          });
          // Load data for the selected tab
          if (index == 0) {
            _loadPending(refresh: true);
          } else {
            _loadCompleted(refresh: true);
          }
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
          child: BlocBuilder<ReservationBloc, ReservationState>(
            builder: (context, state) {
              final count =
                  index == 0
                      ? state.pendingItems.length
                      : state.completedItems.length;
              final text = count > 0 ? '$label ($count)' : label;

              return CustomText(
                text: text,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color:
                    isSelected ? AppPalette.primaryColor : AppPalette.greyColor,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPendingList() {
    return BlocBuilder<ReservationBloc, ReservationState>(
      builder: (context, state) {
        if (state.pendingLoading && state.pendingItems.isEmpty) {
          return _buildShimmerList();
        }

        if (state.pendingError != null && state.pendingItems.isEmpty) {
          return _buildError(
            message: state.pendingError!,
            onRetry: () => _loadPending(refresh: true),
          );
        }

        if (state.pendingItems.isEmpty) {
          return _buildEmpty('No pending items found');
        }

        return RefreshIndicator(
          onRefresh: () async => _loadPending(refresh: true),
          child: ListView.builder(
            controller: _pendingScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount:
                state.pendingItems.length +
                (state.pendingIsLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.pendingItems.length) {
                return _buildLoadMoreIndicator();
              }
              final item = state.pendingItems[index];
              return ReservationItemCard(
                item: item,
                onTap: () => _showQuantityBottomSheet(item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompletedList() {
    return BlocBuilder<ReservationBloc, ReservationState>(
      builder: (context, state) {
        if (state.completedLoading && state.completedItems.isEmpty) {
          return _buildShimmerList();
        }

        if (state.completedError != null && state.completedItems.isEmpty) {
          return _buildError(
            message: state.completedError!,
            onRetry: () => _loadCompleted(refresh: true),
          );
        }

        if (state.completedItems.isEmpty) {
          return _buildEmpty('No completed items found');
        }

        return RefreshIndicator(
          onRefresh: () async => _loadCompleted(refresh: true),
          child: ListView.builder(
            controller: _completedScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount:
                state.completedItems.length +
                (state.completedIsLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.completedItems.length) {
                return _buildLoadMoreIndicator();
              }
              final item = state.completedItems[index];
              return ReservationItemCard(
                item: item,
                quantity: item.quantity,
                ctaText: 'View Details',
                onTap: () => _showCompletedDetails(item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 6,
      itemBuilder: (_, __) => const CardShimmer(),
    );
  }

  Widget _buildError({required String message, required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: message,
            fontSize: 16.sp,
            color: AppPalette.greyColor,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildEmpty(String text) {
    return Center(
      child: CustomText(
        text: text,
        fontSize: 16.sp,
        color: AppPalette.greyColor,
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
