import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/enums/scan_type.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/create_picking_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/picking_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/reservation_bin_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/blocs/bin_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/scan_button.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/bottom_sheet_handle.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/generic_selection_dialog.dart';

class ReservationQuantityBottomSheet extends StatefulWidget {
  final ReservationItemEntity item;
  final String plant;
  final String storageLocation;
  final String movementType;
  final String warehouseCode;
  final WarehouseEntity warehouse;

  const ReservationQuantityBottomSheet({
    super.key,
    required this.item,
    required this.plant,
    required this.storageLocation,
    required this.movementType,
    required this.warehouse,
    required this.warehouseCode,
  });

  @override
  State<ReservationQuantityBottomSheet> createState() =>
      _ReservationQuantityBottomSheetState();
}

class _ReservationQuantityBottomSheetState
    extends State<ReservationQuantityBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final List<TextEditingController> _binQuantityControllers = [];
  final List<FocusNode> _binQuantityFocusNodes = [];
  final Map<String, double> _proposedQuantities = {};
  final List<BinEntity> _selectedBins = [];

  // Bin selection fields
  final _binCodeController = TextEditingController();
  final _binSearchController = TextEditingController();
  final FocusNode _binCodeFocusNode = FocusNode();
  Timer? _debounceTimer;
  String _binSearchQuery = '';

  static const int _pageSize = 10;
  int _skipRecords = 0;

  final List<BinEntity> _dialogBins = [];
  bool _dialogHasMore = false;
  bool _dialogResetPending = false;

  @override
  void initState() {
    super.initState();
    _loadBins();
  }

  void _loadBins() {
    context.read<ReservationBinBloc>().add(
      LoadWarehouseBinsByMaterialEvent(
        warehouseCode: widget.warehouseCode,
        material: widget.item.material,
      ),
    );
  }

  void _loadAllBins({
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
        warehouseCode: widget.item.storageLocation,
        storageType: storageType,
        keyword: keyword,
        lastCount: _pageSize,
        skipRecords: _skipRecords,
      ),
    );

    // Prepare for next page on subsequent calls
    _skipRecords += _pageSize;
  }

  double get _totalSelectedQuantity =>
      _selectedBins.fold<double>(0.0, (sum, bin) => sum + bin.selectedQuantity);

  double get _remainingQuantity =>
      widget.item.remainingQuantity - _totalSelectedQuantity;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReservationBinBloc, ReservationBinState>(
          listener: (context, state) {
            if (state is ReservationBinFailure) {
              CustomToast.error(context, state.message);
            } else if (state is ReservationBinSuccess) {
              setState(() {
                // Add auto-loaded bins to selected bins if not already present
                for (var bin in state.bins) {
                  if (!_selectedBins.any((b) => b.id == bin.id)) {
                    final binWithQty = bin.copyWith(selectedQuantity: 0.0);
                    _selectedBins.add(binWithQty);
                    _proposedQuantities[bin.id] =
                        state.proposedQuantities[bin.id] ?? 0.0;

                    final controller = TextEditingController();
                    final focusNode = FocusNode();
                    controller.addListener(
                      () => _updateBinQuantity(bin.id, controller.text),
                    );
                    _binQuantityControllers.add(controller);
                    _binQuantityFocusNodes.add(focusNode);
                  }
                }
              });
            }
          },
        ),
        BlocListener<PickingBloc, PickingState>(
          listener: (context, state) {
            if (state is CreatePickingFailure) {
              CustomToast.error(context, state.message);
            } else if (state is CreatePickingSuccess) {
              CustomToast.success(context, state.response.message);
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
      child: BlocBuilder<ReservationBinBloc, ReservationBinState>(
        builder: (context, state) {
          final isLoading =
              state is ReservationBinLoading && _selectedBins.isEmpty;

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = MediaQuery.of(context).size.height;
              final bottomSheetHeight = screenHeight * 0.90;

              return SizedBox(
                height: bottomSheetHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppPalette.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Scrollable content area
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const BottomSheetHandle(),
                              _headerWidget(),
                              12.verticalSpace,
                              const Divider(),
                              12.verticalSpace,
                              CustomText(
                                text: "Material Details",
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              10.verticalSpace,
                              _materialDetailsSection(),
                              15.verticalSpace,
                              CustomText(
                                text: "Quantity Details",
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              10.verticalSpace,
                              _quantityDetailsSection(),
                              15.verticalSpace,
                              CustomText(
                                text: "Bin Selection",
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              10.verticalSpace,
                              _binSelectionSection(),
                              if (_selectedBins.isNotEmpty) ...[
                                15.verticalSpace,
                                CustomText(
                                  text: "Bin Details",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                                10.verticalSpace,
                                _binDetailsSection(),
                              ],
                              if (isLoading && _selectedBins.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Fixed buttons at bottom
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          top: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: _actionButtons(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _headerWidget() {
    return Row(
      children: [
        CustomText(
          text: "Quantity",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppPalette.darkGreyColor,
        ),
        const Spacer(),
        if (_selectedBins.isNotEmpty)
          CustomText(
            text: "Total Count: ${_selectedBins.length}",
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppPalette.darkGreyColor,
          ),
      ],
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
            initialValue: widget.item.material,
            readOnly: true,
            isMarquee: true,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          CustomTextFormField(
            label: "Material Code",
            readOnly: true,
            initialValue: widget.item.material,
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
              initialValue: widget.item.remainingQuantity.formatWithCommas,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          ),
          10.horizontalSpace,
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

  Widget _binDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomText(
                  text: "Bin No",
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
          10.verticalSpace,
          ...List.generate(
            _selectedBins.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _buildBinRow(index),
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

  Future<void> _showBinSelectionDialog({String? prefillKeyword}) async {
    if (prefillKeyword != null && prefillKeyword.isNotEmpty) {
      _binSearchController.text = prefillKeyword;
      _binSearchQuery = prefillKeyword;
    } else {
      _binSearchController.clear();
      _binSearchQuery = '';
    }

    _loadAllBins(keyword: _binSearchQuery, resetPagination: true);

    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => BlocProvider.value(
            value: context.read<BinBloc>(),
            child: BlocBuilder<BinBloc, BinState>(
              builder: (context, state) {
                // Start with locally cached dialog bins
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
                    _loadAllBins(keyword: value, resetPagination: true);
                  },
                  onSelected: (bin) {
                    Navigator.pop(context);
                    _onBinSelected(bin);
                  },
                  // Infinite scroll pagination
                  hasMore: _dialogHasMore,
                  onPaginate:
                      _dialogHasMore
                          ? () {
                            _loadAllBins(keyword: _binSearchQuery);
                          }
                          : null,
                );
              },
            ),
          ),
    );
  }

  void _onBinSelected(BinEntity bin) {
    final existingIndex = _selectedBins.indexWhere((b) => b.id == bin.id);

    if (existingIndex != -1) {
      if (existingIndex < _binQuantityControllers.length) {
        final controller = _binQuantityControllers[existingIndex];
        controller.selection = TextSelection(
          baseOffset: controller.text.length,
          extentOffset: controller.text.length,
        );
      }
      return;
    }

    final newBin = bin.copyWith(selectedQuantity: 0.0);
    final quantityController = TextEditingController();
    final quantityFocusNode = FocusNode();
    _binQuantityFocusNodes.add(quantityFocusNode);

    quantityFocusNode.addListener(() {
      if (quantityFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            final index = _selectedBins.indexWhere((b) => b.id == newBin.id);
            _scrollController.jumpTo(700);
          }
        });
      }
    });
    quantityController.addListener(() {
      _updateBinQuantity(newBin.id, quantityController.text);
    });

    setState(() {
      _selectedBins.add(newBin);
      _binQuantityControllers.add(quantityController);
      // Set proposed quantity to 0 if not from auto-loaded bins
      if (!_proposedQuantities.containsKey(newBin.id)) {
        _proposedQuantities[newBin.id] = 0.0;
      }
    });

    _binCodeController.clear();
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

  Widget _buildBinRow(int index) {
    final bin = _selectedBins[index];
    final proposedQty = _proposedQuantities[bin.id] ?? 0.0;
    final controller = _binQuantityControllers[index];
    final focusNode = _binQuantityFocusNodes[index];

    return Dismissible(
      key: ValueKey(bin.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 22.sp),
      ),
      onDismissed: (_) => _removeBin(index),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomText(
              text: bin.binCode,
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
          8.horizontalSpace,
          Expanded(
            flex: 2,
            child: Container(
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppPalette.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 14.sp, height: 2),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                      AppStaticData.quantityFieldMaxLength,
                    ),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty) return newValue;
                      final regex = RegExp(r'^\d*\.?\d{0,3}$');
                      if (regex.hasMatch(newValue.text)) {
                        final value = double.tryParse(newValue.text) ?? 0.0;
                        if (value <= proposedQty) {
                          return newValue;
                        }
                      }
                      return oldValue;
                    }),
                  ],
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateBinQuantity(String binId, String value) {
    final index = _selectedBins.indexWhere((bin) => bin.id == binId);
    if (index == -1) return;

    var quantity = double.tryParse(value) ?? 0.0;
    final proposedQty = _proposedQuantities[binId] ?? 0.0;

    if (quantity > proposedQty && proposedQty > 0) {
      CustomToast.error(
        context,
        "Quantity cannot exceed proposed quantity (${proposedQty.formatWithCommas})",
      );
      _binQuantityControllers[index].text = proposedQty.toString();
      quantity = proposedQty;
    }

    setState(() {
      _selectedBins[index] = _selectedBins[index].copyWith(
        selectedQuantity: quantity,
      );
    });
  }

  void _removeBin(int index) {
    if (index >= 0 && index < _selectedBins.length) {
      _binQuantityControllers[index].dispose();
      _binQuantityFocusNodes[index].dispose();
      setState(() {
        _selectedBins.removeAt(index);
        _binQuantityControllers.removeAt(index);
        _binQuantityFocusNodes.removeAt(index);
      });
    }
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(flex: 3, child: _cancelButton()),
        5.horizontalSpace,
        Expanded(flex: 5, child: _submitButton()),
      ],
    );
  }

  Widget _cancelButton() {
    return CustomButton(
      text: AppTexts.cancel,
      onPressed: () {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
      isBorder: true,
      color: Colors.white,
      textColor: AppPalette.primaryColor,
    );
  }

  Widget _submitButton() {
    return BlocBuilder<PickingBloc, PickingState>(
      builder: (context, state) {
        final isSubmitting = state is CreatePickingLoading;

        return CustomButton(
          text: AppTexts.addToList,
          icon: Icons.list,
          isLoading: isSubmitting,
          onPressed: () {
            FocusScope.of(context).unfocus();

            final binsWithQuantity =
                _selectedBins.where((bin) => bin.selectedQuantity > 0).toList();

            if (binsWithQuantity.isEmpty) {
              CustomToast.error(
                context,
                "Please enter quantity for at least one bin.",
              );
              return;
            }

            // Validate that total doesn't exceed remaining quantity
            if (_totalSelectedQuantity > widget.item.remainingQuantity) {
              CustomToast.error(
                context,
                "Total quantity cannot exceed remaining quantity (${widget.item.remainingQuantity.formatWithCommas})",
              );
              return;
            }

            // Create the request
            final request = CreatePickingRequestModel.fromEntities(
              item: widget.item,
              selectedPlant: widget.plant,
              selectedStorageLocation: widget.storageLocation,
              selectedMovementType: widget.movementType,
              receivingPlant: widget.item.plant,
              receivingStorageLocation: widget.item.storageLocation,
              bins: binsWithQuantity,
            );

            context.read<PickingBloc>().add(
              CreatePickingEvent(request: request),
            );
          },
          radius: 12.r,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _binCodeController.dispose();
    _binSearchController.dispose();
    _binCodeFocusNode.dispose();
    _debounceTimer?.cancel();
    for (var controller in _binQuantityControllers) {
      controller.dispose();
    }
    for (var node in _binQuantityFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
