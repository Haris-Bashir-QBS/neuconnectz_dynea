import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/card_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/entities/production_receipt_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/domain/params/production_receipt_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/blocs/production_receipt_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_items_page_params.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData({bool refresh = true}) {
    final params = ProductionReceiptItemQueryParams(
      plant: widget.params.plant,
      warehouseNumber: widget.params.warehouseCode,
      storageLocation: widget.params.storageLocation,
      trNumber: widget.params.header.trNumber,
      lastCount: 10,
      skipRecords: refresh ? 0 : _getSkipRecords(),
    );
    context.read<ProductionReceiptBloc>().add(
      LoadProductionReceiptItemsEvent(params: params, reset: refresh),
    );
  }

  int _getSkipRecords() {
    final state = context.read<ProductionReceiptBloc>().state;
    return state.items.length;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pixels = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      final state = context.read<ProductionReceiptBloc>().state;
      if (!state.isItemsLoading &&
          !state.isLoadingMore &&
          state.items.length < state.itemsTotalRows) {
        _loadData(refresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Production Receipt Items",
        onTapLeading: () => Navigator.of(context).pop(),
      ),
      body: BlocConsumer<ProductionReceiptBloc, ProductionReceiptState>(
        listener: (context, state) {
          if (state.itemsError != null) {
            CustomToast.error(context, state.itemsError!);
          }
        },
        builder: (context, state) {
          if (state.isItemsLoading && !state.isLoadingMore) {
            return Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.all(16.w),
                //   child: CustomText(
                //     text:
                //         "TR #${widget.params.header.trNumber} • ${widget.params.header.plant}/${widget.params.header.storageLocation}",
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                // 10.verticalSpace,
                ItemListingHeader(
                  leftHeading: "Material",
                  rightHeading: "Quantity",
                ),
                10.verticalSpace,
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 6,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: CardShimmer(),
                        ),
                  ),
                ),
              ],
            );
          }

          if (state.itemsError != null && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: state.itemsError!,
                    fontSize: 16.sp,
                    color: AppPalette.greyColor,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => _loadData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!state.isItemsLoading) {
            if (state.items.isEmpty) {
              return Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.all(16.w),
                  //   child: CustomText(
                  //     text:
                  //         "TR #${widget.params.header.trNumber} • ${widget.params.header.plant}/${widget.params.header.storageLocation}",
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  Expanded(
                    child: Center(
                      child: CustomText(
                        text: 'No items found',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.greyColor,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.all(16.w),
                //   child: CustomText(
                //     text:
                //         "TR #${widget.params.header.trNumber} • ${widget.params.header.plant}/${widget.params.header.storageLocation}",
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                ItemListingHeader(
                  leftHeading: "Material",
                  rightHeading: "Quantity",
                ),
                10.verticalSpace,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _loadData(refresh: true);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 15.w,
                        right: 15.w,
                        bottom: state.isLoadingMore ? 20.h : 0,
                      ),
                      itemCount:
                          state.items.length + (state.isLoadingMore ? 1 : 0),
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

                        return ProductionReceiptRowWidget(
                          item: state.items[index],
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
      ),
    );
  }
}
