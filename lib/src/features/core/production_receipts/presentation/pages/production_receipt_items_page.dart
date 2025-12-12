import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/card_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/blocs/production_receipt_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/widgets/production_receipt_row_widget.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/constants/app_texts.dart';
import '../../../../../widgets/custom_toast.dart';

class ProductionReceiptItemsPage extends StatelessWidget {
  final ProductionReceiptItemsPageParams params;

  const ProductionReceiptItemsPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductionReceiptBloc>(),
      child: _ProductionReceiptItemsView(params: params),
    );
  }
}

class _ProductionReceiptItemsView extends StatefulWidget {
  final ProductionReceiptItemsPageParams params;

  const _ProductionReceiptItemsView({required this.params});

  @override
  State<_ProductionReceiptItemsView> createState() =>
      _ProductionReceiptItemsViewState();
}

class _ProductionReceiptItemsViewState
    extends State<_ProductionReceiptItemsView> {
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

  void _loadPendingData({bool refresh = true}) {
    final params = ProductionReceiptItemQueryParams(
      plant: widget.params.plant,
      warehouseNumber: widget.params.warehouseCode,
      storageLocation: widget.params.storageLocation,
      trNumber: widget.params.header.trNumber,
      lastCount: 10,
      skipRecords: refresh ? 0 : _getPendingSkipRecords(),
    );
    context.read<ProductionReceiptBloc>().add(
      LoadProductionReceiptItemsEvent(params: params, refresh: refresh),
    );
  }

  int _getPendingSkipRecords() {
    final state = context.read<ProductionReceiptBloc>().state;
    return state.pendingSection.skipRecords;
  }

  void _onPendingScroll() {
    if (!_pendingScrollController.hasClients) return;

    final pixels = _pendingScrollController.position.pixels;
    final maxScroll = _pendingScrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<ProductionReceiptBloc>().state;
      if (state.pendingSection.hasMore &&
          !state.pendingSection.isLoadingMore) {
        _loadPendingData(refresh: false);
      }
    }
  }

  void _loadCompletedData({bool refresh = true}) {
    final params = ProductionReceiptItemQueryParams(
      plant: widget.params.plant,
      warehouseNumber: widget.params.warehouseCode,
      storageLocation: widget.params.storageLocation,
      trNumber: widget.params.header.trNumber,
      requirementNumber: widget.params.header.requirementNumber,
      lastCount: 10,
      skipRecords: refresh ? 0 : _getCompletedSkipRecords(),
    );

    context.read<ProductionReceiptBloc>().add(
      LoadCompletedProductionReceiptItemsEvent(params: params, refresh: refresh),
    );
  }

  int _getCompletedSkipRecords() {
    final state = context.read<ProductionReceiptBloc>().state;
    return state.completedSection.skipRecords;
  }

  void _onCompletedScroll() {
    if (!_completedScrollController.hasClients) return;

    final pixels = _completedScrollController.position.pixels;
    final maxScroll = _completedScrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<ProductionReceiptBloc>().state;
      if (state.completedSection.hasMore &&
          !state.completedSection.isLoadingMore) {
        _loadCompletedData(refresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductionReceiptBloc, ProductionReceiptState>(
      listenWhen: (previous, current) {
        final pendingChanged =
            previous.pendingSection.errorMessage !=
            current.pendingSection.errorMessage;
        final completedChanged =
            previous.completedSection.errorMessage !=
            current.completedSection.errorMessage;
        return pendingChanged || completedChanged;
      },
      listener: (context, state) {
        final pendingError = state.pendingSection.errorMessage;
        final completedError = state.completedSection.errorMessage;
        if (pendingError != null && pendingError.isNotEmpty) {
          CustomToast.error(context, pendingError);
        } else if (completedError != null && completedError.isNotEmpty) {
          CustomToast.error(context, completedError);
        }
      },
      child: BlocBuilder<ProductionReceiptBloc, ProductionReceiptState>(
        builder: (context, state) {
          final pendingSection = state.pendingSection;
          final completedSection = state.completedSection;

          return Scaffold(
            appBar: CustomAppBar(title: "Production Receipt Items"),
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
                  leftHeading: "Material",
                  rightHeading: "Quantity",
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: _selectedTab == 0
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

  Widget _buildPendingList(ProductionReceiptItemsSectionState pendingState) {
    if (pendingState.isLoading && pendingState.items.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: CardShimmer(),
        ),
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
              onPressed: () => _loadPendingData(),
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
          return ProductionReceiptRowWidget(
            item: item,
            onTap: () => _navigateToQuantityPage(context, item),
          );
        },
      ),
    );
  }

  Widget _buildCompleteList(ProductionReceiptItemsSectionState completedState) {
    if (completedState.isLoading && completedState.items.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: CardShimmer(),
        ),
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
          return ProductionReceiptRowWidget(
            item: item,
            onTap: () => _navigateToDetailPage(context, item),
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
          child: BlocBuilder<ProductionReceiptBloc, ProductionReceiptState>(
            buildWhen: (previous, current) {
              if (index == 0) {
                return previous.pendingSection.items.length !=
                    current.pendingSection.items.length;
              }
              return previous.completedSection.items.length !=
                  current.completedSection.items.length;
            },
            builder: (context, state) {
              final count = index == 0
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

  Future<void> _navigateToQuantityPage(
    BuildContext context,
    ProductionReceiptItemEntity item,
  ) async {
    final result = await context.pushNamed<bool>(
      AppRoutes.productionReceiptQuantity,
      extra: ProductionReceiptQuantityPageParams(
        header: widget.params.header,
        item: item,
        warehouseCode: widget.params.warehouseCode,
        plant: widget.params.plant,
        storageLocation: widget.params.storageLocation,
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _loadPendingData(refresh: true);
      _loadCompletedData(refresh: true);
    }
  }

  void _navigateToDetailPage(
    BuildContext context,
    ProductionReceiptItemEntity item,
  ) {
    context.pushNamed(
      AppRoutes.completedProductionReceiptItemDetail,
      extra: item,
    );
  }
}
