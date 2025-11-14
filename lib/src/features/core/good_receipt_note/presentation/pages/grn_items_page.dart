import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/putaway_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/quanitity_bottom_sheet.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

import '../../../../../core/constants/app_texts.dart';

class GrnItemsPage extends StatefulWidget {
  final GrnEntity grn;
  final String plant;
  final String warehouseCode;
  final String location;

  const GrnItemsPage({
    super.key,
    required this.grn,
    required this.plant,
    required this.location,
    required this.warehouseCode,
  });

  @override
  State<GrnItemsPage> createState() => _GrnItemsPageState();
}

class _GrnItemsPageState extends State<GrnItemsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData([GrnBloc? bloc]) {
    final params = GrnItemParams(
      plant: widget.plant,
      location: widget.location,
      materialDoc: widget.grn.materialDocument,
      materialDocYear: widget.grn.materialDocYear,
      lastCount: 3,
      skipRecords: 0,
    );
    final grnBloc = bloc ?? context.read<GrnBloc>();
    grnBloc.add(LoadGrnItemsEvent(params: params, refresh: true));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = context.read<GrnBloc>().state;
      if (state is GrnItemsSuccess && state.hasMore && !state.isLoadingMore) {
        final params = GrnItemParams(
          plant: widget.plant,
          location: widget.location,
          materialDoc: widget.grn.materialDocument,
          materialDocYear: widget.grn.materialDocYear,
          lastCount: 4,
          skipRecords: state.skipRecords,
        );
        context.read<GrnBloc>().add(
          LoadGrnItemsEvent(params: params, refresh: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<GrnBloc>();
        // Load initial data after bloc is created
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _loadInitialData(bloc);
          }
        });
        return bloc;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Put Away From GRN'),
        body: Column(
          children: [
            // Item List Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Item List:',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  BlocBuilder<GrnBloc, GrnState>(
                    builder: (context, state) {
                      if (state is GrnItemsSuccess) {
                        return CustomText(
                          text: 'Total Count: ${state.items.length}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        );
                      }
                      return CustomText(
                        text: 'Total Count: 0',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      );
                    },
                  ),
                ],
              ),
            ),

            // Column Headers
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Material Name',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.greyColor,
                  ),
                  CustomText(
                    text: 'Batch Number',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.greyColor,
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // List Items
            Expanded(
              child: BlocConsumer<GrnBloc, GrnState>(
                listener: (context, state) {
                  if (state is GrnItemsFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is GrnItemsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GrnItemsFailure) {
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

                  if (state is GrnItemsSuccess) {
                    if (state.items.isEmpty) {
                      return Center(
                        child: CustomText(
                          text: 'No items found',
                          fontSize: 16.sp,
                          color: AppPalette.greyColor,
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        _loadInitialData();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount:
                            state.items.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.items.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final item = state.items[index];
                          return _buildListItem(item);
                        },
                      ),
                    );
                  }

                  // Initial state - show loading while waiting for first data load
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            // Mark As Complete Button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomButton(
                text: 'Mark As Complete',
                onPressed: () {
                  // TODO: Implement mark as complete
                },
                icon: Icons.check,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQuantityBottomSheet(GrnItemEntity item) async {
    final shouldRefresh = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => BlocProvider(
        create: (_) => sl<PutAwayBloc>(),
        child: GrnQuantityBottomSheet(
          item: item,
          grn: widget.grn,
          showLoader: false,
          onBinsSelected: (bins) {
            debugPrint(
              "Bins submitted: ${bins.map((b) => {'code': b.binCode, 'qty': b.selectedQuantity}).toList()}",
            );
          },
          onTapClose: () {
            debugPrint('Bottom sheet closed');
          },
        ),
      ),
    );

    if (shouldRefresh == true && mounted) {
      _loadInitialData();
    }
  }

  Widget _buildListItem(GrnItemEntity item) {
    return GestureDetector(
      onTap: () {
        _showQuantityBottomSheet(item);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(vertical: 0.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: item.materialDescription,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomText(
                        text: item.batch,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Material Number and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Material No: ${item.material}',
                        fontSize: 12.sp,
                        color: AppPalette.greyColor,
                      ),
                      CustomText(
                        text: 'Quantity: ${item.quantity.formatWithCommas}',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: AppPalette.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Center(
                child: CustomText(
                  text: AppTexts.tapToProcess,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
