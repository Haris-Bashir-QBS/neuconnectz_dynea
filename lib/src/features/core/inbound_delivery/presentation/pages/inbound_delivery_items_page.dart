import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logger/logger.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/widgets/status_dialog.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/entities/inbound_delivery_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/domain/params/inbound_delivery_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/blocs/inbound_delivery_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/params/inbound_delivery_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/widgets/inbound_delivery_row_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/inbound_delivery/presentation/widgets/inbound_delivery_item_widget.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_texts.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../widgets/custom_toast.dart';

class InboundDeliveryItemsPage extends StatelessWidget {
  final InboundDeliveryItemsPageParams params;

  const InboundDeliveryItemsPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InboundDeliveryBloc>(),
      child: _InboundDeliveryItemsView(params: params),
    );
  }
}

class _InboundDeliveryItemsView extends StatefulWidget {
  final InboundDeliveryItemsPageParams params;

  const _InboundDeliveryItemsView({required this.params});

  @override
  State<_InboundDeliveryItemsView> createState() =>
      _InboundDeliveryItemsViewState();
}

class _InboundDeliveryItemsViewState extends State<_InboundDeliveryItemsView> {
  final ScrollController _pendingScrollController = ScrollController();
  final ScrollController _completedScrollController = ScrollController();
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    Logger().i(
      "InboundDeliveryItemsPage opened with params of whc: ${widget.params.warehouseCode}",
    );
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
    final params = InboundDeliveryItemQueryParams(
      plant: widget.params.plant,
      storageLocation: widget.params.location,
      outboundDeliveryNo: widget.params.inboundDelivery.outboundDeliveryNo,
      stoNo: widget.params.inboundDelivery.stoNo,
      lastCount: 10,
      skipRecords: 0,
    );
    context.read<InboundDeliveryBloc>().add(
      LoadInboundDeliveryItemsEvent(params: params, refresh: true),
    );
  }

  void _onPendingScroll() {
    if (_pendingScrollController.position.pixels ==
        _pendingScrollController.position.maxScrollExtent) {
      final state = context.read<InboundDeliveryBloc>().state;
      if (state.pendingSection.hasMore && !state.pendingSection.isLoadingMore) {
        final params = InboundDeliveryItemQueryParams(
          plant: widget.params.plant,
          storageLocation: widget.params.location,
          outboundDeliveryNo: widget.params.inboundDelivery.outboundDeliveryNo,
          stoNo: widget.params.inboundDelivery.stoNo,
          warehouseNumber: widget.params.warehouseCode,
          lastCount: 10,
          skipRecords: state.pendingSection.skipRecords,
        );
        context.read<InboundDeliveryBloc>().add(
          LoadInboundDeliveryItemsEvent(params: params, refresh: false),
        );
      }
    }
  }

  void _loadCompletedData({bool refresh = true}) {
    final params = InboundDeliveryItemQueryParams(
      plant: widget.params.plant,
      storageLocation: widget.params.location,
      warehouseNumber: widget.params.warehouseCode,
      outboundDeliveryNo: widget.params.inboundDelivery.outboundDeliveryNo,
      stoNo: widget.params.inboundDelivery.stoNo,
      lastCount: 10,
      skipRecords: 0,
    );

    context.read<InboundDeliveryBloc>().add(
      LoadCompletedInboundDeliveryItemsEvent(params: params, refresh: refresh),
    );
  }

  void _onCompletedScroll() {
    if (_completedScrollController.position.pixels ==
        _completedScrollController.position.maxScrollExtent) {
      final state = context.read<InboundDeliveryBloc>().state;
      if (state.completedSection.hasMore &&
          !state.completedSection.isLoadingMore) {
        final params = InboundDeliveryItemQueryParams(
          plant: widget.params.plant,
          storageLocation: widget.params.location,
          warehouseNumber: widget.params.warehouseCode,
          outboundDeliveryNo: widget.params.inboundDelivery.outboundDeliveryNo,
          stoNo: widget.params.inboundDelivery.stoNo,
          lastCount: 10,
          skipRecords: state.completedSection.skipRecords,
        );
        context.read<InboundDeliveryBloc>().add(
          LoadCompletedInboundDeliveryItemsEvent(
            params: params,
            refresh: false,
          ),
        );
      }
    }
  }

  Future<void> _showQuantityBottomSheet(InboundDeliveryItemEntity item) async {
    final result = await context.pushNamed<bool>(
      AppRoutes.inboundDeliveryQuantity,
      extra: InboundDeliveryQuantityPageParams(
        inboundDelivery: widget.params.inboundDelivery,
        item: item,
        warehouseCode: widget.params.warehouseCode,
        plant: widget.params.plant,
        storageLocation: widget.params.location,
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _loadPendingData();
      _loadCompletedData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InboundDeliveryBloc, InboundDeliveryState>(
      listenWhen: (previous, current) {
        final pendingChanged =
            previous.pendingSection.errorMessage !=
            current.pendingSection.errorMessage;
        final completedChanged =
            previous.completedSection.errorMessage !=
            current.completedSection.errorMessage;
        final deleteErrorChanged =
            previous.deleteError != current.deleteError;
        final deleteResponseChanged =
            previous.deleteResponse != current.deleteResponse;
        final deleteLoadingToFailure =
            previous.isDeleting && !current.isDeleting && current.deleteError != null;
        final deleteLoadingToSuccess =
            previous.isDeleting && !current.isDeleting && current.deleteResponse != null;
        return pendingChanged ||
            completedChanged ||
            deleteErrorChanged ||
            deleteResponseChanged ||
            deleteLoadingToFailure ||
            deleteLoadingToSuccess;
      },
      listener: (context, state) {
        if (!mounted) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          final pendingError = state.pendingSection.errorMessage;
          final completedError = state.completedSection.errorMessage;
          if (pendingError != null && pendingError.isNotEmpty) {
            CustomToast.error(context, pendingError);
          } else if (completedError != null && completedError.isNotEmpty) {
            CustomToast.error(context, completedError);
          } else if (state.deleteError != null && state.deleteError!.isNotEmpty) {
            CustomToast.error(context, state.deleteError!);
          } else if (state.deleteResponse != null) {
            final message = state.deleteResponse!.message.isNotEmpty == true
                ? state.deleteResponse!.message
                : 'Putaway against inbound delivery STO deleted successfully';
            CustomToast.success(context, message);
            _loadPendingData();
            _loadCompletedData();
          }
        });
      },
      child: BlocBuilder<InboundDeliveryBloc, InboundDeliveryState>(
        builder: (context, state) {
          final pendingSection = state.pendingSection;
          final completedSection = state.completedSection;

          return Scaffold(
            appBar: CustomAppBar(title: "Inbound Delivery Items"),
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
      ),
    );
  }

  Widget _buildPendingList(InboundDeliveryItemsSectionState pendingState) {
    if (pendingState.isLoading && pendingState.items.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        itemBuilder: (_, __) => const InboundDeliveryItemShimmer(),
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
          return InboundDeliveryItemWidget(
            item: item,
            onTap: () => _showQuantityBottomSheet(item),
          );
        },
      ),
    );
  }

  Widget _buildCompleteList(InboundDeliveryItemsSectionState completedState) {
    if (completedState.isLoading && completedState.items.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        itemBuilder: (_, __) => const InboundDeliveryItemShimmer(),
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
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Slidable(
              key: ValueKey('completed_${item.stoNo}_${item.stoItemNo}_${item.outboundDeliveryNo}_$index'),
              groupTag: 'completed_items',
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) => _showDeleteConfirmation(context, item),
                    backgroundColor: AppPalette.redColor,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: AppTexts.delete,
                    flex: 1,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                    autoClose: false,
                    spacing: 0,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              child: InboundDeliveryItemWidget(
                item: item,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.completedInboundDeliveryItemDetail,
                    extra: item,
                  );
                },
              ),
            ),
          );
        },
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
          if (index == 0) {
            _loadPendingData();
          } else {
            _loadCompletedData();
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
          child: BlocBuilder<InboundDeliveryBloc, InboundDeliveryState>(
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

  void _showDeleteConfirmation(
    BuildContext context,
    InboundDeliveryItemEntity item,
  ) {
    if (item.docNum == null) {
      CustomToast.error(context, 'Document number not available');
      return;
    }

    AnimatedStatusDialog.show(
      context: context,
      isSuccess: false,
      title: AppTexts.deletePutawayRequest,
      message: AppTexts.deletePutawayRequestMessage,
      primaryButtonText: AppTexts.delete,
      secondaryButtonText: AppTexts.cancel,
      onPrimaryTap: () {
        _deletePutawayAgainstInboundDeliverySto(context, item.docNum!);
      },
    );
  }

  void _deletePutawayAgainstInboundDeliverySto(BuildContext context, int docNum) {
    context.read<InboundDeliveryBloc>().add(
      DeletePutawayAgainstInboundDeliveryStoEvent(docNum: docNum),
    );
  }
}
