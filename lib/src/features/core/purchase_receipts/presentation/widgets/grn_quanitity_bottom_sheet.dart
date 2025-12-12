import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/enums/scan_type.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/data/models/purchase_order_grn_create_putaway_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/domain/entities/purchase_order_grn_list_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/blocs/purchase_order_grn_putaway/purchase_order_grn_putaway_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/widgets/bin_details_section.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/widgets/scan_button.dart';
import 'package:neuconnectz_dynea/src/widgets/bottom_sheet_handle.dart';
import 'package:neuconnectz_dynea/src/widgets/generic_selection_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/blocs/bin_bloc.dart';

import '../../../../../core/constants/app_palette.dart';
import '../../../../../core/constants/app_texts.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/custom_text_formfield.dart';
import '../../../../../widgets/custom_toast.dart';

class GrnQuantityBottomSheet extends StatefulWidget {
  final bool? showLoader;
  final PurchaseOrderGrnEntity grn;
  final ValueChanged<List<BinEntity>> onBinsSelected;
  final VoidCallback onTapClose;
  final PurchaseOrderGrnItemEntity? item;

  const GrnQuantityBottomSheet({
    super.key,
    this.item,
    required this.grn,
    this.showLoader,
    required this.onBinsSelected,
    required this.onTapClose,
  });

  @override
  State<GrnQuantityBottomSheet> createState() => _GrnQuantityBottomSheetState();
}

class _GrnQuantityBottomSheetState extends State<GrnQuantityBottomSheet> {
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _binCodeFocusNode = FocusNode();
  final _binCodeController = TextEditingController();
  final _binSearchController = TextEditingController();
  final _remainingQuantityController = TextEditingController();

  final List<BinEntity> _selectedBins = [];
  final List<TextEditingController> _binQuantityControllers = [];
  final _binQuantityFocusNodes = <FocusNode>[];
  Timer? _debounceTimer;
  String _binSearchQuery = '';

  // Pagination for bins
  static const int _pageSize = 10;
  int _skipRecords = 0;

  // Local state to manage bin dialog pagination/results
  final List<BinEntity> _dialogBins = [];
  bool _dialogHasMore = false;
  bool _dialogResetPending = false;

  double get _totalSelectedQuantity => _selectedBins.fold<double>(
    0.0,
    (sum, bin) => sum + (bin.selectedQuantity),
  );

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
        // plant: widget.item?.plant,
        warehouseCode: widget.grn.warehouseNumber,
        storageType: storageType ?? widget.grn.destStorageType,
        keyword: keyword,
        lastCount: _pageSize,
        skipRecords: _skipRecords,
      ),
    );

    // Prepare for next page on subsequent calls
    _skipRecords += _pageSize;
  }

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.item?.quantity.toString() ?? '';
    _updateRemainingQuantity();
  }

  void _updateRemainingQuantity() {
    final actualQuantity = widget.item?.quantity ?? 0.0;
    final remaining = actualQuantity - _totalSelectedQuantity;
    _remainingQuantityController.text = remaining.formatWithCommas;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      PurchaseOrderGrnPutAwayBloc,
      PurchaseOrderGrnPutAwayState
    >(
      listener: (context, state) {
        if (state is CreatePurchaseOrderGrnPutAwayFailure) {
          CustomToast.error(context, state.message);
        } else if (state is CreatePurchaseOrderGrnPutAwaySuccess) {
          CustomToast.success(context, state.response.message);
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final isSubmitting =
            (widget.showLoader ?? false) ||
            state is CreatePurchaseOrderGrnPutAwayLoading;
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.94,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppPalette.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AbsorbPointer(
                        absorbing: isSubmitting,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const BottomSheetHandle(),
                            _headerWidget(),
                            12.verticalSpace,
                            Divider(),
                            12.verticalSpace,
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                spacing: 10.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "Material Details",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                  _materialDetailsSection(),
                                  15.verticalSpace,
                                  CustomText(
                                    text: "Quantity Details",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                  _quantityDetailsSection(),
                                  15.verticalSpace,
                                  CustomText(
                                    text: "Bin Selection",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                  _binSelectionSection(),
                                  if (_selectedBins.isNotEmpty) ...[
                                    15.verticalSpace,
                                    CustomText(
                                      text: "Bin Details",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                    _binDetailsSection(),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            _actionButtons(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
      onTap: () {
        _binSearchController.clear();
        _showBinSelectionDialog();
      },
      //readOnly: false,
      //onTap: () {
      // Scroll to top when bin field is tapped
      // if (_scrollController.hasClients) {
      //   _scrollController.animateTo(
      //     0,
      //     duration: Duration(milliseconds: 300),
      //     curve: Curves.easeOut,
      //   );
      // }
      //  _showBinSelectionDialog();
      // },
      // suffixIcon: IconButton(
      //   icon: Icon(Icons.list),
      //   //color: context.primaryColor,
      //   onPressed: () {
      //     // // Scroll to top when search icon is tapped
      //     // if (_scrollController.hasClients) {
      //     //   _scrollController.animateTo(
      //     //     0,
      //     //     duration: Duration(milliseconds: 300),
      //     //     curve: Curves.easeOut,
      //     //   );
      //     // }
      //     _binSearchController.clear();
      //     _showBinSelectionDialog();
      //   },
      // ),
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

    _loadBins(keyword: _binSearchQuery, resetPagination: true);

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
                    _loadBins(keyword: value, resetPagination: true);
                  },
                  onSelected: (bin) {
                    Navigator.pop(context);
                    _onBinSelected(bin);
                    _scrollController.jumpTo(700);
                  },
                  // Infinite scroll pagination
                  hasMore: _dialogHasMore,
                  onPaginate:
                      _dialogHasMore
                          ? () {
                            _loadBins(
                              keyword: _binSearchQuery,
                              storageType: widget.grn.destStorageType,
                            );
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
    final quantityController = TextEditingController(
      text:
          newBin.selectedQuantity > 0 ? newBin.selectedQuantity.toString() : '',
    );
    final quantityFocusNode = FocusNode();
    _binQuantityFocusNodes.add(quantityFocusNode);

    quantityFocusNode.addListener(() {
      if (quantityFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            final index = _selectedBins.indexWhere((b) => b.id == newBin.id);
            final offset = index * 80.0;
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
    });

    _binCodeController.clear();
  }

  void _updateBinQuantity(String binId, String value) {
    final index = _selectedBins.indexWhere((bin) => bin.id == binId);
    if (index == -1) return;

    final quantity = double.tryParse(value) ?? 0.0;

    setState(() {
      _selectedBins[index] = _selectedBins[index].copyWith(
        selectedQuantity: quantity,
      );
    });

    _updateRemainingQuantity();
  }

  void _removeBin(int index) {
    if (index >= 0 && index < _selectedBins.length) {
      _binQuantityControllers[index].dispose();
      setState(() {
        _selectedBins.removeAt(index);
        _binQuantityControllers.removeAt(index);
      });
      _updateRemainingQuantity();
    }
  }

  Widget _binDetailsSection() {
    return BinDetailsSection(
      bins: _selectedBins,
      controllers: _binQuantityControllers,
      focusNodes: _binQuantityFocusNodes,
      onDelete: (index) => _removeBin(index),
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
    await Future.delayed(Duration(milliseconds: 0), () {});
    _showBinSelectionDialog(prefillKeyword: res);
  }

  Widget _headerWidget() {
    return Row(
      children: [
        CustomText(
          text: "Add Quantity",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppPalette.darkGreyColor,
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(flex: 3, child: _cancelButton()),
        5.horizontalSpace,
        Expanded(flex: 5, child: _addToListButton()),
      ],
    );
  }

  Widget _cancelButton() {
    return CustomButton(
      text: AppTexts.cancel,
      onPressed: _onTapClose,
      isBorder: true,
      color: Colors.white,
      textColor: context.primaryColor,
    );
  }

  void _onTapClose() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    widget.onTapClose();
  }

  Widget _addToListButton() {
    final bloc = context.watch<PurchaseOrderGrnPutAwayBloc>();
    final isSubmitting = bloc.state is CreatePurchaseOrderGrnPutAwayLoading;
    return CustomButton(
      text: AppTexts.addToList,
      icon: Icons.list,
      isLoading: isSubmitting,
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        final actualQuantity = widget.item?.quantity ?? 0.0;
        final selectedQuantity = _totalSelectedQuantity;

        if (_selectedBins.isEmpty) {
          CustomToast.error(context, "Please add at least one bin entry.");
          return;
        }
        final binsWithZeroQuantity =
            _selectedBins.where((bin) => bin.selectedQuantity <= 0).toList();

        if (binsWithZeroQuantity.isNotEmpty) {
          CustomToast.error(
            context,
            "Please enter quantity for all bins or remove bins with zero quantity.",
          );
          return;
        }
        if ((selectedQuantity - actualQuantity).abs() >= 0.001) {
          CustomToast.error(
            context,
            "Sum of bin quantities must match the actual quantity (${actualQuantity.formatWithCommas}).",
          );
          return;
        }

        if (widget.item == null) {
          CustomToast.error(context, "Item details unavailable.");
          return;
        }

        widget.onBinsSelected(List<BinEntity>.from(_selectedBins));

        final request = CreatePurchaseOrderGrnPutAwayRequestModel.fromEntities(
          grn: widget.grn,
          item: widget.item!,
          bins: _selectedBins,
        );

        context.read<PurchaseOrderGrnPutAwayBloc>().add(
          CreatePutAwayAgainstGrEvent(request: request),
        );
      },
      radius: 12.r,
    );
  }

  Container _materialDetailsSection() {
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
            initialValue: widget.item?.materialDescription,
            readOnly: true,
            isMarquee: true,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          CustomTextFormField(
            label: "Material Number",
            readOnly: true,
            initialValue: widget.item?.material,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          if (widget.item?.batch.isNotEmpty ?? false)
            CustomTextFormField(
              label: "Batch",
              readOnly: true,
              initialValue: widget.item?.batch,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: "Plant",
                  readOnly: true,
                  initialValue: widget.item?.plant,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomTextFormField(
                  label: "Storage Location",
                  readOnly: true,
                  initialValue: widget.item?.storageLocation,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
            ],
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
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: "Actual Quantity",
                  readOnly: true,
                  initialValue: widget.item?.quantity.formatWithCommas,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomTextFormField(
                  label: "Remaining Quantity",
                  readOnly: true,
                  controller: _remainingQuantityController,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _getQuantityError(String? value) {
    if (value == null || value.isEmpty) {
      return "Quantity can't be empty";
    }

    final quantity = double.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid number';
    }

    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }

    final actualQuantity = widget.item?.quantity;
    if (actualQuantity != null && quantity > actualQuantity) {
      return "Quantity can't be greater than actual quantity";
    }

    return null;
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  void _disposeResources() {
    _scrollController.dispose();
    _quantityFocusNode.dispose();
    _quantityController.dispose();
    _binCodeController.dispose();
    _binSearchController.dispose();
    _binCodeFocusNode.dispose();
    _remainingQuantityController.dispose();
    for (var controller in _binQuantityControllers) {
      controller.dispose();
    }
    for (var node in _binQuantityFocusNodes) {
      node.dispose();
    }
  }
}
