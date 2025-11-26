import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/entities/grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/params/grn_item_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/putaway_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/params/grn_items_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_row_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/grn_row_widget.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/quanitity_bottom_sheet.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/completed_grn_item_detail_page.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
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
  final ScrollController _pendingScrollController = ScrollController();
  final ScrollController _completedScrollController = ScrollController();
  int _selectedTab = 0;
  bool _completedLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    _grnBloc = sl<GrnBloc>();
    _pendingScrollController.addListener(_onPendingScroll);
    _completedScrollController.addListener(_onCompletedScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadInitialData();
    });
  }

  @override
  void dispose() {
    _pendingScrollController.dispose();
    _completedScrollController.dispose();
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

  void _onPendingScroll() {
    if (_selectedTab == 1) return;

    if (_pendingScrollController.position.pixels ==
        _pendingScrollController.position.maxScrollExtent) {
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

  void _loadCompletedData({bool refresh = true}) {
    if (_selectedTab == 0) return;

    final params = GrnItemQueryParams(
      plant: widget.params.plant,
      location: widget.params.location,
      materialDoc: widget.params.grn.materialDocument,
      materialDocYear: widget.params.grn.materialDocYear,
      lastCount: 10,
      skipRecords: 0,
    );

    _grnBloc.add(LoadCompletedGrnItemsEvent(params: params, refresh: refresh));
    _completedLoadedOnce = true;
  }

  void _onCompletedScroll() {
    if (_selectedTab == 0) return;

    if (_completedScrollController.position.pixels ==
        _completedScrollController.position.maxScrollExtent) {
      final state = _grnBloc.state;
      if (state is CompletedGrnItemsSuccess &&
          state.hasMore &&
          !state.isLoadingMore) {
        final params = GrnItemQueryParams(
          plant: widget.params.plant,
          location: widget.params.location,
          materialDoc: widget.params.grn.materialDocument,
          materialDocYear: widget.params.grn.materialDocYear,
          lastCount: 10,
          skipRecords: state.skipRecords,
        );
        _grnBloc.add(
          LoadCompletedGrnItemsEvent(params: params, refresh: false),
        );
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

    if (!mounted) return;

    if (_selectedTab == 0) {
      _loadInitialData();
    } else if (_completedLoadedOnce) {
      _loadCompletedData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _grnBloc,
      child: Scaffold(
        appBar: CustomAppBar(title: AppTexts.putAwayAgainstGrn),
        body: Column(
          children: [
            //CustomSearchField(controller: TextEditingController()),
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
                      ? _buildPendingList()
                      : _buildCompleteList(),
            ),
            //_markAsCompleteButton(),
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
              controller: _pendingScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.items.length)
                  return const CircularProgressIndicator();
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
    return BlocConsumer<GrnBloc, GrnState>(
      listener: (context, state) {
        if (state is CompletedGrnItemsFailure) {
          CustomToast.error(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is CompletedGrnItemsLoading) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 6,
            itemBuilder: (_, __) => const GrnItemShimmer(),
          );
        }

        if (state is CompletedGrnItemsFailure) {
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
                  onPressed: () => _loadCompletedData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is CompletedGrnItemsSuccess) {
          if (state.items.isEmpty) {
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
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.items.length)
                  return CircularProgressIndicator();
                return GrnItemWidget(
                  item: state.items[index],
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CompletedGrnItemDetailPage(
                                item: state.items[index],
                              ),
                        ),
                      ),
                );
              },
            ),
          );
        }

        return _completedLoadedOnce
            ? const Center(child: CircularProgressIndicator())
            : Center(
              child: CustomText(
                text: 'Tap the Completed tab to load data',
                fontSize: 16.sp,
                color: AppPalette.greyColor,
                textAlign: TextAlign.center,
              ),
            );
      },
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
          _loadInitialData();
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
          child: BlocBuilder<GrnBloc, GrnState>(
            builder: (context, state) {
              String text = label;

              if (state is GrnItemsSuccess && index == 0) {
                text = '$label (${state.items.length})';
              } else if (state is CompletedGrnItemsSuccess && index == 1) {
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
