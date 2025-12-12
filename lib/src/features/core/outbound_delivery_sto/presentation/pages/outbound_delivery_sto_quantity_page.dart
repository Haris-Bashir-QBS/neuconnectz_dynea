import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/enums/scan_type.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/widgets/scan_button.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/create_stock_transfer_order_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/data/models/get_and_update_stocks_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/domain/params/stocks_by_storage_bin_params.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_event.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/outbound_delivery_sto_state.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/blocs/stocks_by_storage_bin_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/outbound_delivery_sto/presentation/params/outbound_delivery_sto_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/blocs/bin_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';
import 'package:neuconnectz_dynea/src/core/utils/bin_group_helper.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/generic_selection_dialog.dart';

class OutboundDeliveryStoQuantityPage extends StatelessWidget {
  final OutboundDeliveryStoQuantityPageParams params;

  const OutboundDeliveryStoQuantityPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BinBloc>()),
        BlocProvider(create: (_) => sl<StocksByStorageBinBloc>()),
        BlocProvider(create: (_) => sl<OutboundDeliveryStoBloc>()),
      ],
      child: _OutboundDeliveryStoQuantityView(params: params),
    );
  }
}

class _OutboundDeliveryStoQuantityView extends StatefulWidget {
  final OutboundDeliveryStoQuantityPageParams params;

  const _OutboundDeliveryStoQuantityView({required this.params});

  @override
  State<_OutboundDeliveryStoQuantityView> createState() =>
      _OutboundDeliveryStoQuantityViewState();
}

class _OutboundDeliveryStoQuantityViewState
    extends State<_OutboundDeliveryStoQuantityView> {
  final ScrollController _scrollController = ScrollController();
  final _binCodeController = TextEditingController();
  final _binSearchController = TextEditingController();
  final FocusNode _binCodeFocusNode = FocusNode();

  String _binSearchQuery = '';
  BinEntity? _selectedBin;
  List<StockEntity> _batchStocks = [];
  final Map<String, TextEditingController> _batchQuantityControllers = {};
  final Map<String, FocusNode> _batchQuantityFocusNodes = {};
  final Map<String, String> _batchFieldErrors = {};
  bool _showBinSelection = false;

  // Group stocks by storageBin, storageType, and storageSection
  List<BinGroup> get _groupedBins {
    return BinGroup.groupStocks(_batchStocks);
  }

  // Pagination for bins
  static const int _pageSize = 10;
  int _skipRecords = 0;

  // Local state to manage bin dialog pagination/results
  final List<BinEntity> _dialogBins = [];
  bool _dialogHasMore = false;
  bool _dialogResetPending = false;

  double get _totalSelectedQuantity =>
      _batchStocks.fold<double>(0.0, (sum, stock) {
        final qty =
            double.tryParse(_batchQuantityControllers[stock.id]?.text ?? '0') ??
            0.0;
        return sum + qty;
      });

  double get _remainingQuantity =>
      widget.params.item.deliveryQuantity - _totalSelectedQuantity;

  @override
  void initState() {
    super.initState();
    // Load stocks on screen initialization without bin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadStocksByBin();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _binCodeController.dispose();
    _binSearchController.dispose();
    _binCodeFocusNode.dispose();
    for (var controller in _batchQuantityControllers.values) {
      controller.dispose();
    }
    for (var node in _batchQuantityFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _loadBins({
    String? keyword,
    String? storageType,
    bool resetPagination = false,
  }) {
    if (resetPagination) {
      _skipRecords = 0;
      _dialogBins.clear();
      _dialogHasMore = false;
      _dialogResetPending = true;
    }

    context.read<BinBloc>().add(
      LoadBinsEvent(
        warehouseCode: widget.params.warehouseCode,
        storageType: storageType,
        keyword: keyword,
        lastCount: _pageSize,
        skipRecords: _skipRecords,
      ),
    );

    _skipRecords += _pageSize;
  }

  void _loadStocksByBin({BinEntity? bin}) {
    final params = StocksByStorageBinParams(
      plant: widget.params.plant,
      whsCode: widget.params.warehouseCode,
      storageLocation: widget.params.storageLocation,
      material: widget.params.item.material,
      storageBin: bin?.binCode ?? '',
    );

    context.read<StocksByStorageBinBloc>().add(
      LoadStocksByStorageBinEvent(params: params),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StocksByStorageBinBloc, StocksByStorageBinState>(
          listener: (context, state) {
            if (state is StocksByStorageBinFailure) {
              // Don't clear old data on failure - keep it visible
              CustomToast.error(context, state.message);
            } else if (state is StocksByStorageBinSuccess) {
              setState(() {
                for (var stock in state.stocks) {
                  if (!_batchStocks.any((s) => s.id == stock.id)) {
                    _batchStocks.add(stock);
                    if (!_batchQuantityControllers.containsKey(stock.id)) {
                      _batchQuantityControllers[stock.id] =
                          TextEditingController();
                      _batchQuantityFocusNodes[stock.id] = FocusNode();
                      _batchQuantityFocusNodes[stock.id]!.addListener(() {
                        _updateBatchQuantity(stock.id);
                      });
                      _batchQuantityControllers[stock.id]!.addListener(() {
                        _updateBatchQuantity(stock.id);
                      });
                    }
                  }
                }
              });
            }
          },
        ),
        BlocListener<OutboundDeliveryStoBloc, OutboundDeliveryStoState>(
          listener: (context, state) {
            // Handle create stock transfer order
            if (state.createStockTransferOrder.isError) {
              CustomToast.error(context, state.createStockTransferOrder.error!);
            } else if (state.createStockTransferOrder.isSuccess) {
              CustomToast.success(
                context,
                state.createStockTransferOrder.data!.message,
              );
              context.pop(true);
            }
            if (state.syncStocks.isError) {
              CustomToast.error(context, state.syncStocks.error!);
            } else if (state.syncStocks.isSuccess) {
              // Show success message if available
              final message =
                  state.syncStocks.data?.message ??
                  'Stocks synchronized successfully';
              CustomToast.success(context, message);
              if (_selectedBin != null) {
                _loadStocksByBin(bin: _selectedBin);
              } else {
                _loadStocksByBin();
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(title: "Add Quantity"),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _syncStocksFromSap,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Material Details",
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 10.h),
                      _materialDetailsSection(),
                      SizedBox(height: 20.h),
                      CustomText(
                        text: "Quantity Details",
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 10.h),
                      _quantityDetailsSection(),
                      SizedBox(height: 20.h),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(
                                0.0,
                                1.0,
                              ), // Start from bottom
                              end: Offset.zero, // End at normal position
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: child,
                          );
                        },
                        child:
                            _showBinSelection
                                ? Column(
                                  key: const ValueKey('bin_selection'),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _binSelectionHeader(),
                                    SizedBox(height: 10.h),
                                    _binSelectionSection(),
                                  ],
                                )
                                : const SizedBox.shrink(
                                  key: ValueKey('bin_selection_empty'),
                                ),
                      ),
                      BlocBuilder<
                        StocksByStorageBinBloc,
                        StocksByStorageBinState
                      >(
                        builder: (context, state) {
                          if (state is StocksByStorageBinLoading) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h),
                                _binDetailsHeader(),
                                SizedBox(height: 10.h),
                                _binDetailsShimmer(),
                              ],
                            );
                          }
                          // Show data only when not loading
                          if (_batchStocks.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h),
                                _binDetailsHeader(),
                                SizedBox(height: 10.h),
                                _binBatchDetailsSection(),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppPalette.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(child: _actionButtons()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _materialDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        spacing: 5.h,
        children: [
          CustomTextFormField(
            label: "Material Name",
            initialValue: widget.params.item.itemDescription,
            readOnly: true,
            isMarquee: true,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          CustomTextFormField(
            label: "Material Code",
            readOnly: true,
            initialValue: widget.params.item.material,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _quantityDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomTextFormField(
              label: "Actual Quantity",
              readOnly: true,
              initialValue:
                  widget.params.item.deliveryQuantity.formatWithCommas,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomTextFormField(
              label: "Remaining Quantity",
              readOnly: true,
              initialValue: _remainingQuantity.formatWithCommas,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _binSelectionSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(spacing: 10.h, children: [_binCodeNumberTextField()]),
    );
  }

  Widget _binCodeNumberTextField() {
    // Update controller text when bin is selected
    if (_selectedBin != null &&
        _binCodeController.text != _selectedBin!.binCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _binCodeController.text = _selectedBin!.binCode;
        }
      });
    }

    return CustomTextFormField(
      label: AppTexts.binCode,
      hint: AppTexts.scanAndType,
      controller: _binCodeController,
      focusNode: _binCodeFocusNode,
      readOnly: true,
      onTap: () {
        _binSearchController.clear();
        _showBinSelectionDialog();
      },
      rightActionWidget: ScanButton(
        onTap: () async {
          await openScanner(scanType: FieldScanType.barcode);
        },
      ),
    );
  }

  Widget _binDetailsHeader() {
    return BlocBuilder<OutboundDeliveryStoBloc, OutboundDeliveryStoState>(
      builder: (context, state) {
        final isSyncing = state.syncStocks.isLoading;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Bin Details",
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bin Selection toggle button
                InkWell(
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) {
                        setState(() {
                          _showBinSelection = !_showBinSelection;
                        });
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 18.sp,
                          color: AppPalette.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: "Bin Selection",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppPalette.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Refresh icon button
                InkWell(
                  onTap: isSyncing ? null : () {
                    FocusScope.of(context).unfocus();
                    _syncStocksFromSap();
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: isSyncing
                        ? SizedBox(
                            width: 18.sp,
                            height: 18.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppPalette.primaryColor,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.refresh,
                            size: 18.sp,
                            color: AppPalette.primaryColor,
                          ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _binSelectionHeader() {
    return CustomText(
      text: "Bin Selection",
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
    );
  }

  Widget _binDetailsShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bin header shimmer
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppPalette.lightGreyColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          width: 100.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            // Table headers shimmer
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Batch rows shimmer (3 rows)
            ...List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _binBatchDetailsSection() {
    final groupedBins = _groupedBins;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          groupedBins.map((BinGroup group) {
            final stocks = group.stocks;
            return Container(
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bin header with info and batch quantity sum
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 15.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.lightGreyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Bin: ${group.storageBin}",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              if (group.storageType.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: "Storage Type: ${group.storageType}",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppPalette.darkGreyColor,
                                ),
                              ],
                            ],
                          ),
                        ),
                        CustomText(
                          text: "Total Qty: ${stocks.fold<double>(0.0, (sum, stock) => sum + stock.availableStock).formatWithCommas}",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppPalette.darkGreyColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // Table headers
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomText(
                          text: "Batch No",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.darkGreyColor,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomText(
                          text: "Proposed Qty",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.darkGreyColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomText(
                          text: "Act Qty",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.darkGreyColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Batch rows for this group
                  ...List.generate(
                    stocks.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _buildBatchRow(stocks[index]),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildBatchRow(StockEntity stock) {
    final controller = _batchQuantityControllers[stock.id]!;
    final focusNode = _batchQuantityFocusNodes[stock.id]!;
    final proposedQty = stock.availableStock;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: CustomText(
            text: stock.batch,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppPalette.lightGreyColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: CustomText(
                text: proposedQty.formatWithCommas,
                fontSize: 14.sp,
                color: AppPalette.darkGreyColor,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 45.h),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppPalette.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 14.sp),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                      AppStaticData.quantityFieldMaxLength,
                    ),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty) return newValue;
                      final regex = RegExp(r'^\d*\.?\d{0,3}$');
                      return regex.hasMatch(newValue.text)
                          ? newValue
                          : oldValue;
                    }),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                  ),
                ),
              ),
              if (_batchFieldErrors[stock.id] != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    _batchFieldErrors[stock.id]!,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 11.sp, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateBatchQuantity(String stockId) {
    final controller = _batchQuantityControllers[stockId];
    if (controller == null) return;

    final trimmedValue = controller.text.trim();
    final quantity = double.tryParse(trimmedValue);
    final stock = _batchStocks.firstWhere((s) => s.id == stockId);
    final proposedQty = stock.availableStock;

    final otherSelectedTotal = _batchStocks
        .where((s) => s.id != stockId)
        .fold<double>(0.0, (sum, s) {
          final qty =
              double.tryParse(_batchQuantityControllers[s.id]?.text ?? '0') ??
              0.0;
          return sum + qty;
        });

    final remainingActual =
        widget.params.item.deliveryQuantity - otherSelectedTotal;

    double allowedQty = remainingActual;
    if (proposedQty > 0 && proposedQty < allowedQty) {
      allowedQty = proposedQty;
    }

    String? errorMessage;

    if (trimmedValue.isEmpty) {
      setState(() {
        _batchFieldErrors.remove(stockId);
      });
      return;
    }

    if (quantity == null) return;

    if (allowedQty <= 0 && quantity > 0) {
      errorMessage = "Qty exceed";
    } else if (quantity > allowedQty) {
      errorMessage = "Qty exceed";
    }

    if (errorMessage != null) {
      setState(() {
        _batchFieldErrors[stockId] = errorMessage!;
      });
      return;
    }

    setState(() {
      _batchFieldErrors.remove(stockId);
    });
  }

  Future<void> _showBinSelectionDialog({String? prefillKeyword}) async {
    if (prefillKeyword != null && prefillKeyword.isNotEmpty) {
      _binSearchController.text = prefillKeyword;
      _binSearchQuery = prefillKeyword;
    } else {
      _binSearchController.clear();
      _binSearchQuery = '';
    }

    final binBloc = context.read<BinBloc>();

    _loadBins(keyword: _binSearchQuery, resetPagination: true);

    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => BlocProvider.value(
            value: binBloc,
            child: BlocBuilder<BinBloc, BinState>(
              builder: (context, state) {
                List<BinEntity> bins = _dialogBins;

                if (state is BinSuccess) {
                  if (_dialogResetPending) {
                    _dialogBins
                      ..clear()
                      ..addAll(state.bins);
                    _dialogResetPending = false;
                  } else {
                    _dialogBins.addAll(state.bins);
                  }

                  bins = _dialogBins;
                  _dialogHasMore = state.bins.length == _pageSize;
                } else if (state is BinFailure) {
                  _dialogHasMore = false;
                }

                final bool isInitialLoading =
                    state is BinLoading && bins.isEmpty;

                return GenericSelectionDialog<BinEntity>(
                  items: bins,
                  controller: _binSearchController,
                  loading: isInitialLoading,
                  isTable: true,
                  tableHeaders: ["Storage Type", "Section", "Bin Code"],
                  tableRowBuilder:
                      (bin) => [
                        bin.storageType,
                        bin.storageSection,
                        bin.binCode,
                      ],
                  noDataText:
                      state is BinFailure
                          ? state.message
                          : AppErrors.noBinsFound,
                  headingText: "Select Bin",
                  searchLabel: "Search Bin Code",
                  titleBuilder:
                      (bin) => CustomText(
                        text: bin.binCode,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                  subTitleBuilder:
                      (bin) => CustomText(
                        text: bin.storageType,
                        fontSize: 12.sp,
                        color: AppPalette.darkGreyColor,
                      ),
                  onChanged: (value) {
                    _binSearchQuery = value;
                    _loadBins(keyword: value, resetPagination: true);
                  },
                  onSelected: (bin) {
                    Navigator.pop(context);
                    _onBinSelected(bin);
                  },
                  hasMore: _dialogHasMore,
                  onPaginate:
                      _dialogHasMore
                          ? () {
                            _loadBins(keyword: _binSearchQuery);
                          }
                          : null,
                );
              },
            ),
          ),
    );
  }

  void _onBinSelected(BinEntity bin) {
    setState(() {
      _selectedBin = bin;
      _binCodeController.text = bin.binCode;
      // Don't clear old data - keep it visible
    });

    // Load new data for selected bin
    _loadStocksByBin(bin: bin);
  }

  void _clearBatchData() {
    // Clear previous controllers
    for (var controller in _batchQuantityControllers.values) {
      controller.dispose();
    }
    for (var node in _batchQuantityFocusNodes.values) {
      node.dispose();
    }

    setState(() {
      _batchStocks.clear();
      _batchQuantityControllers.clear();
      _batchQuantityFocusNodes.clear();
      _batchFieldErrors.clear();
    });
  }

  void _clearBatchDataWithoutSetState() {
    // Clear previous controllers without setState (for use in listeners)
    for (var controller in _batchQuantityControllers.values) {
      controller.dispose();
    }
    for (var node in _batchQuantityFocusNodes.values) {
      node.dispose();
    }
    _batchQuantityControllers.clear();
    _batchQuantityFocusNodes.clear();
    _batchFieldErrors.clear();
  }

  Future<void> _syncStocksFromSap() async {
    final request = GetAndUpdateStocksRequestModel(
      plant: widget.params.plant,
      storageLocation: widget.params.storageLocation,
      warehouseNumber: widget.params.warehouseCode,
      material: widget.params.item.material,
    );

    context.read<OutboundDeliveryStoBloc>().add(
      GetAndUpdateStocksFromSapEvent(request: request),
    );
  }

  Future<void> openScanner({required FieldScanType scanType}) async {
    String? res = await Utils.scanBarcode(context, title: AppTexts.scan);

    if (res == "-1") {
      return;
    }
    if ((res ?? "").isEmpty) {
      if (!mounted) return;
      CustomToast.error(context, "Couldn't read the code. Please try again.");
      return;
    }

    _binSearchController.text = res!;
    _binSearchQuery = res;
    await Future.delayed(const Duration(milliseconds: 0), () {});
    _showBinSelectionDialog(prefillKeyword: res);
  }

  Widget _actionButtons() {
    return Row(
      children: [
        // Expanded(flex: 3, child: _cancelButton()),
        // SizedBox(width: 5.w),
        Expanded(flex: 5, child: _submitButton()),
      ],
    );
  }

  Widget _cancelButton() {
    return CustomButton(
      text: AppTexts.cancel,
      onPressed: () {
        FocusScope.of(context).unfocus();
        context.pop();
      },
      isBorder: true,
      color: Colors.white,
      textColor: AppPalette.primaryColor,
    );
  }

  Widget _submitButton() {
    return BlocBuilder<OutboundDeliveryStoBloc, OutboundDeliveryStoState>(
      builder: (context, state) {
        final isSubmitting = state.createStockTransferOrder.isLoading;

        return CustomButton(
          text: AppTexts.proceed,
          isLoading: isSubmitting,
          onPressed: () {
            FocusScope.of(context).unfocus();
            final batchesWithQuantity =
                _batchStocks.where((stock) {
                  final qty =
                      double.tryParse(
                        _batchQuantityControllers[stock.id]?.text ?? '0',
                      ) ??
                      0.0;
                  return qty > 0;
                }).toList();

            if (batchesWithQuantity.isEmpty) {
              CustomToast.error(
                context,
                "Please enter quantity for at least one batch.",
              );
              return;
            }

            // Validate that total equals delivery quantity
            if (_totalSelectedQuantity > widget.params.item.deliveryQuantity) {
              CustomToast.error(
                context,
                "Total quantity cannot exceed delivery quantity (${widget.params.item.deliveryQuantity.formatWithCommas})",
              );
              return;
            }

            if (_totalSelectedQuantity < widget.params.item.deliveryQuantity) {
              CustomToast.error(
                context,
                "Total quantity must equal delivery quantity (${widget.params.item.deliveryQuantity.formatWithCommas})",
              );
              return;
            }

            // Create batch quantities map
            final batchQuantitiesMap = <String, double>{};
            for (var stock in _batchStocks) {
              final qty =
                  double.tryParse(
                    _batchQuantityControllers[stock.id]?.text ?? '0',
                  ) ??
                  0.0;
              if (qty > 0) {
                batchQuantitiesMap[stock.id] = qty;
              }
            }

            // Create the request
            final request = CreateStockTransferOrderRequestModel.fromEntities(
              item: widget.params.item,
              selectedPlant: widget.params.plant,
              selectedWarehouse: widget.params.warehouseCode,
              stocks: _batchStocks,
              batchQuantitiesMap: batchQuantitiesMap,
            );
            log(request.toJson().toString() ?? "");
            context.read<OutboundDeliveryStoBloc>().add(
              CreateStockTransferOrderEvent(request: request),
            );
          },
          radius: 12.r,
        );
      },
    );
  }
}


