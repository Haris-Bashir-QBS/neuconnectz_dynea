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

  @override
  void initState() {
    super.initState();
    _grnBloc = sl<GrnBloc>();
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
    _grnBloc.close();
    super.dispose();
  }

  void _loadPendingData() {
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
    if (_pendingScrollController.position.pixels ==
        _pendingScrollController.position.maxScrollExtent) {
      final state = _grnBloc.state;
      if (state.pendingSection.hasMore && !state.pendingSection.isLoadingMore) {
        final params = GrnItemQueryParams(
          plant: widget.params.plant,
          location: widget.params.location,
          materialDoc: widget.params.grn.materialDocument,
          materialDocYear: widget.params.grn.materialDocYear,
          lastCount: 10,
          skipRecords: state.pendingSection.skipRecords,
        );
        _grnBloc.add(LoadGrnItemsEvent(params: params, refresh: false));
      }
    }
  }

  void _loadCompletedData({bool refresh = true}) {
    final params = GrnItemQueryParams(
      plant: widget.params.plant,
      location: widget.params.location,
      materialDoc: widget.params.grn.materialDocument,
      materialDocYear: widget.params.grn.materialDocYear,
      lastCount: 10,
      skipRecords: 0,
    );

    _grnBloc.add(LoadCompletedGrnItemsEvent(params: params, refresh: refresh));
  }

  void _onCompletedScroll() {
    if (_completedScrollController.position.pixels ==
        _completedScrollController.position.maxScrollExtent) {
      final state = _grnBloc.state;
      if (state.completedSection.hasMore &&
          !state.completedSection.isLoadingMore) {
        final params = GrnItemQueryParams(
          plant: widget.params.plant,
          location: widget.params.location,
          materialDoc: widget.params.grn.materialDocument,
          materialDocYear: widget.params.grn.materialDocYear,
          lastCount: 10,
          skipRecords: state.completedSection.skipRecords,
        );
        _grnBloc.add(
          LoadCompletedGrnItemsEvent(params: params, refresh: false),
        );
      }
    }
  }

  Future<void> _showQuantityBottomSheet(GrnItemEntity item) async {
    await showModalBottomSheet<bool>(
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

    _loadPendingData();
    _loadCompletedData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _grnBloc,
      child: BlocListener<GrnBloc, GrnState>(
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
        child: BlocBuilder<GrnBloc, GrnState>(
          builder: (context, state) {
            final pendingSection = state.pendingSection;
            final completedSection = state.completedSection;

            return Scaffold(
              appBar: CustomAppBar(title: AppTexts.putAwayAgainstGrn),
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

  Widget _buildPendingList(GrnItemsSectionState pendingState) {
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
          return GrnItemWidget(
            item: item,
            onTap: () => _showQuantityBottomSheet(item),
          );
        },
      ),
    );
  }

  Widget _buildCompleteList(GrnItemsSectionState completedState) {
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
            completedState.items.length + (completedState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == completedState.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final item = completedState.items[index];
          return GrnItemWidget(
            item: item,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CompletedGrnItemDetailPage(
                          item: item,
                        ),
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
          child: BlocBuilder<GrnBloc, GrnState>(
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
}
