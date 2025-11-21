import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/putaway_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/params/grn_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_row_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_row_widget.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/quanitity_bottom_sheet.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

import '../../../../../core/constants/app_texts.dart';
import '../../../../../widgets/custom_toast.dart';

class GrnItemsPage extends StatefulWidget {
  final GrnItemsPageParams params;

  const GrnItemsPage({super.key, required this.params});

  @override
  State<GrnItemsPage> createState() => _GrnItemsPageState();
}

class _GrnItemsPageState extends State<GrnItemsPage> {
  late final GrnBloc _grnBloc;
  final ScrollController _scrollController = ScrollController();
  int _selectedTab = 0; // 0 = Pending, 1 = Complete

  @override
  void initState() {
    super.initState();
    _grnBloc = sl<GrnBloc>();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadInitialData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _grnBloc.close();
    super.dispose();
  }

  void _loadInitialData() {
    if (_selectedTab == 1) return;

    final params = GrnItemQueryParams(
      plant: widget.params.plant,
      location: widget.params.location,
      materialDoc: widget.params.grn.materialDocument,
      materialDocYear: widget.params.grn.materialDocYear,
      lastCount: 10,
      skipRecords: 0,
    );
    _grnBloc.add(LoadGrnItemsEvent(params: params, refresh: true));
  }

  void _onScroll() {
    if (_selectedTab == 1) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = _grnBloc.state;
      if (state is GrnItemsSuccess && state.hasMore && !state.isLoadingMore) {
        final params = GrnItemQueryParams(
          plant: widget.params.plant,
          location: widget.params.location,
          materialDoc: widget.params.grn.materialDocument,
          materialDocYear: widget.params.grn.materialDocYear,
          lastCount: 10,
          skipRecords: state.skipRecords,
        );
        _grnBloc.add(LoadGrnItemsEvent(params: params, refresh: false));
      }
    }
  }

  Future<void> _showQuantityBottomSheet(GrnItemEntity item) async {
    final shouldRefresh = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder:
          (context) => BlocProvider(
            create: (_) => sl<PutAwayBloc>(),
            child: GrnQuantityBottomSheet(
              item: item,
              grn: widget.params.grn,
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

    if (shouldRefresh == true && mounted) _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _grnBloc,
      child: Scaffold(
        appBar: CustomAppBar(title: AppTexts.putAwayAgainstGrn),
        body: Column(
          children: [
            CustomSearchField(controller: TextEditingController()),
            Row(
              children: [
                Expanded(child: _buildTab(0, 'Pending')),
                Expanded(child: _buildTab(1, 'Complete')),
              ],
            ),
            10.verticalSpace,
            ItemListingHeader(
              leftHeading: "Material Name",
              rightHeading: "Quantity",
            ),
            SizedBox(height: 8.h),
            Expanded(
              child:
                  _selectedTab == 0
                      ? _buildPendingList()
                      : _buildCompleteList(),
            ),
            _markAsCompleteButton(),
          ],
        ),
      ),
    );
  }

  AnimatedSwitcher _markAsCompleteButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1.0,
          child: child,
        );
      },
      child:
          _selectedTab == 1
              ? Padding(
                key: const ValueKey('markCompleteButton'),
                padding: EdgeInsets.all(16.w),
                child: CustomButton(
                  text: 'Mark As Complete',
                  onPressed: () {
                    // TODO: Implement mark as complete
                  },
                  icon: Icons.check,
                ),
              )
              : const SizedBox(key: ValueKey('emptySpace')),
    );
  }

  Widget _buildPendingList() {
    return BlocConsumer<GrnBloc, GrnState>(
      listener: (context, state) {
        if (state is GrnItemsFailure) CustomToast.error(context, state.message);
      },
      builder: (context, state) {
        if (state is GrnItemsLoading) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 6,
            itemBuilder: (_, __) => const GrnItemShimmer(),
          );
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
            onRefresh: () async => _loadInitialData(),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.items.length) return const GrnItemShimmer();
                return GrnItemWidget(
                  item: state.items[index],
                  onTap: () => _showQuantityBottomSheet(state.items[index]),
                );
              },
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCompleteList() {
    return Center(
      child: CustomText(
        text: 'Complete list will be available soon',
        fontSize: 16.sp,
        color: AppPalette.greyColor,
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
        if (index == 0) _loadInitialData();
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
          child: BlocBuilder<GrnBloc, GrnState>(
            builder: (context, state) {
              String text = label;

              if (state is GrnItemsSuccess && index == 0) {
                text = '$label (${state.items.length})';
              }

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
