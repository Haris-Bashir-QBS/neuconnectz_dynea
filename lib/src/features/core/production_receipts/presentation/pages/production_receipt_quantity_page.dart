import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/enums/scan_type.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/data/models/create_production_receipt_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/blocs/production_receipt_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/production_receipts/presentation/params/production_receipt_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/purchase_receipts/presentation/widgets/scan_button.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/blocs/bin_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/widgets/bin_details_section.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/generic_selection_dialog.dart';

class ProductionReceiptQuantityPage extends StatelessWidget {
  final ProductionReceiptQuantityPageParams params;

  const ProductionReceiptQuantityPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductionReceiptBloc>()),
        BlocProvider(create: (_) => sl<BinBloc>()),
      ],
      child: _ProductionReceiptQuantityView(params: params),
    );
  }
}

class _ProductionReceiptQuantityView extends StatefulWidget {
  final ProductionReceiptQuantityPageParams params;

  const _ProductionReceiptQuantityView({required this.params});

  @override
  State<_ProductionReceiptQuantityView> createState() =>
      _ProductionReceiptQuantityViewState();
}

class _ProductionReceiptQuantityViewState
    extends State<_ProductionReceiptQuantityView> {
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

  static const int _pageSize = 10;
  int _skipRecords = 0;

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
        warehouseCode: widget.params.warehouseCode,
        storageType: storageType,
        keyword: keyword,
        lastCount: _pageSize,
        skipRecords: _skipRecords,
      ),
    );

    _skipRecords += _pageSize;
  }

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.params.item.trQuantity.toString();
    _updateRemainingQuantity();
  }

  void _updateRemainingQuantity() {
    final actualQuantity = widget.params.item.trQuantity;
    final remaining = actualQuantity - _totalSelectedQuantity;
    _remainingQuantityController.text = remaining.formatWithCommas;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductionReceiptBloc, ProductionReceiptState>(
      listener: (context, state) {
        if (state.createError != null) {
          CustomToast.error(context, state.createError!);
        } else if (state.createResponse != null) {
          CustomToast.success(context, state.createResponse!.message);
          context.pop(true);
        }
      },
      builder: (context, state) {
        final isSubmitting = state.isCreating;
        return Scaffold(
          appBar: CustomAppBar(title: "Add Quantity"),
          body: AbsorbPointer(
            absorbing: isSubmitting,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          CustomText(
                            text: "Bin Selection",
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                          SizedBox(height: 10.h),
                          _binSelectionSection(),
                          if (_selectedBins.isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            CustomText(
                              text: "Bin Details",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                            SizedBox(height: 10.h),
                            _binDetailsSection(),
                          ],
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.scaffoldBackgroundColor,
                  ),
                  child: SafeArea(child: _actionButtons()),
                ),
              ],
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

    final binBloc = context.read<BinBloc>();

    _loadBins(keyword: _binSearchQuery, resetPagination: true);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
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
              tableRowBuilder: (bin) => [
                bin.storageType,
                bin.storageSection,
                bin.binCode,
              ],
              noDataText: state is BinFailure
                  ? state.message
                  : AppErrors.noBinsFound,
              headingText: "Select Bin",
              searchLabel: "Search Bin Code",
              titleBuilder: (bin) => CustomText(
                text: bin.binCode,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              subTitleBuilder: (bin) => CustomText(
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
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(700);
                }
              },
              hasMore: _dialogHasMore,
              onPaginate: _dialogHasMore
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
      text: newBin.selectedQuantity > 0
          ? newBin.selectedQuantity.toString()
          : '',
    );
    final quantityFocusNode = FocusNode();
    _binQuantityFocusNodes.add(quantityFocusNode);

    quantityFocusNode.addListener(() {
      if (quantityFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
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
      _binQuantityFocusNodes[index].dispose();
      setState(() {
        _selectedBins.removeAt(index);
        _binQuantityControllers.removeAt(index);
        _binQuantityFocusNodes.removeAt(index);
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
    await Future.delayed(const Duration(milliseconds: 0), () {});
    _showBinSelectionDialog(prefillKeyword: res);
  }

  Widget _actionButtons() {
    return Row(children: [Expanded(flex: 5, child: _proceedButton())]);
  }

  Widget _proceedButton() {
    final bloc = context.watch<ProductionReceiptBloc>();
    final isSubmitting = bloc.state.isCreating;
    return CustomButton(
      text: AppTexts.proceed,
      isLoading: isSubmitting,
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;

        final actualQuantity = widget.params.item.trQuantity;
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

        final request = CreateProductionReceiptRequestModel.fromEntities(
          header: widget.params.header,
          item: widget.params.item,
          bins: _selectedBins,
          plant: widget.params.plant,
          warehouse: widget.params.warehouseCode,
          storageLocation: widget.params.storageLocation,
        );

        context.read<ProductionReceiptBloc>().add(
              CreateProductionReceiptEvent(request: request),
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
            label: "Material Number",
            readOnly: true,
            initialValue: widget.params.item.material,
            fillColor: AppPalette.lightGreyColor,
            enabled: false,
          ),
          if (widget.params.item.batch.isNotEmpty)
            CustomTextFormField(
              label: "Batch",
              readOnly: true,
              initialValue: widget.params.item.batch,
              fillColor: AppPalette.lightGreyColor,
              enabled: false,
            ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: "Plant",
                  readOnly: true,
                  initialValue: widget.params.item.plant,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextFormField(
                  label: "Storage Location",
                  readOnly: true,
                  initialValue: widget.params.item.storageLocation,
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
                  initialValue: widget.params.item.trQuantity.formatWithCommas,
                  fillColor: AppPalette.lightGreyColor,
                  enabled: false,
                ),
              ),
              SizedBox(width: 10.w),
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

