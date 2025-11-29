import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_row_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/outbound_delivery_sto_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/items/outbound_delivery_sto_item_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/params/outbound_delivery_sto_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/widgets/outbound_delivery_sto_item_card.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

class OutboundDeliveryStoItemsPage extends StatelessWidget {
  final OutboundDeliveryStoItemsPageParams params;

  const OutboundDeliveryStoItemsPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OutboundDeliveryStoItemBloc>(),
      child: _OutboundDeliveryStoItemsView(params: params),
    );
  }
}

class _OutboundDeliveryStoItemsView extends StatefulWidget {
  final OutboundDeliveryStoItemsPageParams params;

  const _OutboundDeliveryStoItemsView({required this.params});

  @override
  State<_OutboundDeliveryStoItemsView> createState() =>
      _OutboundDeliveryStoItemsViewState();
}

class _OutboundDeliveryStoItemsViewState
    extends State<_OutboundDeliveryStoItemsView> {
  final ScrollController _pendingScrollController = ScrollController();
  final ScrollController _completedScrollController = ScrollController();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _pendingScrollController.addListener(_onPendingScroll);
    _completedScrollController.addListener(_onCompletedScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadPendingData();
        _loadCompletedData();
      }
    });
  }

  @override
  void dispose() {
    _pendingScrollController.dispose();
    _completedScrollController.dispose();
    super.dispose();
  }

  void _loadPendingData() {
    final params = OutboundDeliveryStoItemParams(
      deliveryNo: widget.params.delivery,
      itemNo: '',
      material: '',
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      movementType: widget.params.movementType,
      lastCount: 10,
      skipRecords: 0,
    );
    context.read<OutboundDeliveryStoItemBloc>().add(
      LoadStoItemsEvent(params: params, refresh: true),
    );
  }

  void _onPendingScroll() {
    if (_pendingScrollController.position.pixels ==
        _pendingScrollController.position.maxScrollExtent) {
      final state = context.read<OutboundDeliveryStoItemBloc>().state;
      if (state.pendingSection.hasMore && !state.pendingSection.isLoadingMore) {
        final params = OutboundDeliveryStoItemParams(
          deliveryNo: widget.params.delivery,
          itemNo: '',
          material: '',
          plant: widget.params.plant,
          storageLocation: widget.params.storageLocation,
          movementType: widget.params.movementType,
          lastCount: 10,
          skipRecords: state.pendingSection.skipRecords,
        );
        context.read<OutboundDeliveryStoItemBloc>().add(
          LoadStoItemsEvent(params: params, refresh: false),
        );
      }
    }
  }

  void _loadCompletedData({bool refresh = true}) {
    final params = OutboundDeliveryStoItemParams(
      deliveryNo: widget.params.delivery,
      itemNo: '',
      material: '',
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      movementType: widget.params.movementType,
      lastCount: 10,
      skipRecords: 0,
    );

    context.read<OutboundDeliveryStoItemBloc>().add(
      LoadCompletedStoItemsEvent(params: params, refresh: refresh),
    );
  }

  void _onCompletedScroll() {
    if (_completedScrollController.position.pixels ==
        _completedScrollController.position.maxScrollExtent) {
      final state = context.read<OutboundDeliveryStoItemBloc>().state;
      if (state.completedSection.hasMore &&
          !state.completedSection.isLoadingMore) {
        final params = OutboundDeliveryStoItemParams(
          deliveryNo: widget.params.delivery,
          itemNo: '',
          material: '',
          plant: widget.params.plant,
          storageLocation: widget.params.storageLocation,
          movementType: widget.params.movementType,
          lastCount: 10,
          skipRecords: state.completedSection.skipRecords,
        );
        context.read<OutboundDeliveryStoItemBloc>().add(
          LoadCompletedStoItemsEvent(params: params, refresh: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      OutboundDeliveryStoItemBloc,
      OutboundDeliveryStoItemState
    >(
      builder: (context, state) {
        final pendingSection = state.pendingSection;
        final completedSection = state.completedSection;

        return Scaffold(
          appBar: const CustomAppBar(title: AppTexts.outboundDeliverySto),
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
                    _selectedTab == 0
                        ? _buildPendingList(pendingSection)
                        : _buildCompleteList(completedSection),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingList(StoItemsSectionState pendingState) {
    if (pendingState.isLoading && pendingState.items.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        itemBuilder: (_, __) => const GrnItemShimmer(),
      );
    }

    if (pendingState.errorMessage != null && pendingState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: pendingState.errorMessage!,
              fontSize: 16.sp,
              color: AppPalette.greyColor,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadPendingData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (pendingState.items.isEmpty) {
      return Center(
        child: CustomText(
          text: 'No items found',
          fontSize: 16.sp,
          color: AppPalette.greyColor,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadPendingData(),
      child: ListView.builder(
        controller: _pendingScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount:
            pendingState.items.length + (pendingState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == pendingState.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final item = pendingState.items[index];
          return OutboundDeliveryStoItemCard(
            item: item,
            onTap: () {
              // Handle tap - show bottom sheet or navigate
            },
          );
        },
      ),
    );
  }

  Widget _buildCompleteList(StoItemsSectionState completedState) {
    if (completedState.isLoading && completedState.items.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        itemBuilder: (_, __) => const GrnItemShimmer(),
      );
    }

    if (completedState.errorMessage != null && completedState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: completedState.errorMessage!,
              fontSize: 16.sp,
              color: AppPalette.greyColor,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => _loadCompletedData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (completedState.items.isEmpty) {
      return Center(
        child: CustomText(
          text: 'No completed items found',
          fontSize: 16.sp,
          color: AppPalette.greyColor,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadCompletedData(),
      child: ListView.builder(
        controller: _completedScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount:
            completedState.items.length +
            (completedState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == completedState.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final item = completedState.items[index];
          return OutboundDeliveryStoItemCard(
            item: item,
            ctoText: AppTexts.viewDetails,
            onTap: () {
              // Handle tap - navigate to detail page
            },
          );
        },
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
          _loadPendingData();
        } else {
          _loadCompletedData();
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
          child: BlocBuilder<
            OutboundDeliveryStoItemBloc,
            OutboundDeliveryStoItemState
          >(
            buildWhen: (previous, current) {
              if (index == 0) {
                return previous.pendingSection.items.length !=
                    current.pendingSection.items.length;
              }
              return previous.completedSection.items.length !=
                  current.completedSection.items.length;
            },
            builder: (context, state) {
              final count =
                  index == 0
                      ? state.pendingSection.items.length
                      : state.completedSection.items.length;
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
}
