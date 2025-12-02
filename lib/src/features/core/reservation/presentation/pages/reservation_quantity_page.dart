import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/enums/scan_type.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/widgets/scan_button.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/data/models/create_picking_request_model.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/reservation_item_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/picking_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/reservation_bin_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/params/reservation_quantity_page_params.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/generic_selection_dialog.dart';

class ReservationQuantityPage extends StatelessWidget {
  final ReservationQuantityPageParams params;

  const ReservationQuantityPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ReservationBinBloc>()),
        BlocProvider(create: (_) => sl<PickingBloc>()),
      ],
      child: _ReservationQuantityView(params: params),
    );
  }
}

class _ReservationQuantityView extends StatefulWidget {
  final ReservationQuantityPageParams params;

  const _ReservationQuantityView({required this.params});

  @override
  State<_ReservationQuantityView> createState() =>
      _ReservationQuantityViewState();
}

class _ReservationQuantityViewState extends State<_ReservationQuantityView> {
  final ScrollController _scrollController = ScrollController();
  final List<TextEditingController> _binQuantityControllers = [];
  final List<FocusNode> _binQuantityFocusNodes = [];
  final Map<String, double> _proposedQuantities = {};
  final List<BinEntity> _selectedBins = [];
  final Map<String, String> _binFieldErrors = {};

  // Bin selection fields
  final _binCodeController = TextEditingController();
  final _binSearchController = TextEditingController();
  final FocusNode _binCodeFocusNode = FocusNode();
  Timer? _debounceTimer;
  String _binSearchQuery = '';

  double get _targetQuantity => widget.params.item.remainingQuantity;

  double get _autoLoadedCoverage => _selectedBins.fold<double>(
    0.0,
    (sum, bin) => sum + (_proposedQuantities[bin.id] ?? 0.0),
  );

  double get _autoCoverageDeficit =>
      max(0, _targetQuantity - _autoLoadedCoverage);

  @override
  void initState() {
    super.initState();
    _loadWarehouseBinsByMaterial();
  }

  void _loadWarehouseBinsByMaterial() {
    context.read<ReservationBinBloc>().add(
      LoadWarehouseBinsByMaterialEvent(
        warehouseCode: widget.params.warehouseCode,
        material: widget.params.item.material,
      ),
    );
  }

  double get _totalSelectedQuantity =>
      _selectedBins.fold<double>(0.0, (sum, bin) => sum + bin.selectedQuantity);

  double get _remainingQuantity =>
      max(0, widget.params.item.remainingQuantity - _totalSelectedQuantity);

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
                double remainingCoverage = _autoCoverageDeficit;
                final List<BinEntity> fallbackBins = [];

                for (var bin in state.bins) {
                  if (remainingCoverage <= 0) break;
                  if (_selectedBins.any((b) => b.id == bin.id)) continue;

                  final proposedQty = state.proposedQuantities[bin.id] ?? 0.0;
                  if (proposedQty <= 0) {
                    fallbackBins.add(bin);
                    continue;
                  }

                  _appendBin(bin, proposedQuantity: proposedQty);
                  remainingCoverage -= proposedQty;
                }

                if (remainingCoverage > 0) {
                  for (final bin in fallbackBins) {
                    if (_selectedBins.any((b) => b.id == bin.id)) continue;
                    _appendBin(bin);
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
              context.pop(true);
            }
          },
        ),
      ],
      child: BlocBuilder<ReservationBinBloc, ReservationBinState>(
        builder: (context, state) {
          final isLoading =
              state is ReservationBinLoading && _selectedBins.isEmpty;

          return Scaffold(
            appBar: CustomAppBar(title: "Quantity"),
            body: Column(
              children: [
                // Scrollable content area
                Expanded(
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
                        _headerWidget(),
                        SizedBox(height: 20.h),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
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
          );
        },
      ),
    );
  }

  Widget _headerWidget() {
    return Row(
      children: [
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
            initialValue: widget.params.item.material,
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
                  widget.params.item.remainingQuantity.formatWithCommas,
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
          SizedBox(height: 15.h),
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
          SizedBox(height: 10.h),
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

    // Capture the bloc before showing dialog
    final reservationBinBloc = context.read<ReservationBinBloc>();

    // Load bins by material
    _loadWarehouseBinsByMaterial();

    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => BlocProvider.value(
            value: reservationBinBloc,
            child: BlocBuilder<ReservationBinBloc, ReservationBinState>(
              builder: (context, state) {
                List<BinEntity> bins = [];

                if (state is ReservationBinSuccess) {
                  bins = state.bins;

                  // Filter bins by search query if provided
                  if (_binSearchQuery.isNotEmpty) {
                    bins =
                        bins.where((bin) {
                          final searchLower = _binSearchQuery.toLowerCase();
                          return bin.binCode.toLowerCase().contains(
                                searchLower,
                              ) ||
                              bin.storageType.toLowerCase().contains(
                                searchLower,
                              ) ||
                              (bin.storageSection.isNotEmpty &&
                                  bin.storageSection
                                      .toLowerCase()
                                      .contains(searchLower));
                        }).toList();
                  }
                }

                final bool isInitialLoading =
                    state is ReservationBinLoading && bins.isEmpty;

                // Check if any bin has a section (not empty)
                final hasSection = bins.isNotEmpty && bins.any(
                  (bin) => bin.storageSection.isNotEmpty,
                );

                return GenericSelectionDialog<BinEntity>(
                  items: bins,
                  controller: _binSearchController,
                  loading: isInitialLoading,
                  isTable: true,
                  tableHeaders: hasSection
                      ? ["Storage Type", "Section", "Bin Code"]
                      : ["Storage Type", "Bin Code"],
                  tableRowBuilder: (bin) => hasSection
                      ? [
                          bin.storageType,
                          bin.storageSection,
                          bin.binCode,
                        ]
                      : [
                          bin.storageType,
                          bin.binCode,
                        ],
                  noDataText:
                      state is ReservationBinFailure
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
                    // Rebuild to filter bins
                    setState(() {});
                  },
                  onSelected: (bin) {
                    Navigator.pop(context);
                    _onBinSelected(bin);
                  },
                  // No pagination for GetWarehouseBinsByMaterial
                  hasMore: false,
                  onPaginate: null,
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

    // Get proposed quantity from the bloc state
    final reservationBinState = context.read<ReservationBinBloc>().state;
    double? proposedQty;
    if (reservationBinState is ReservationBinSuccess) {
      proposedQty = reservationBinState.proposedQuantities[bin.id];
    }

    setState(() {
      _appendBin(bin, proposedQuantity: proposedQty);
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    border: Border.all(
                      color: AppPalette.primaryColor,
                      width: 1,
                    ),
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
                if (_binFieldErrors[bin.id] != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      _binFieldErrors[bin.id]!,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 11.sp, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateBinQuantity(String binId, String value) {
    final index = _selectedBins.indexWhere((bin) => bin.id == binId);
    if (index == -1) return;

    final trimmedValue = value.trim();
    final quantity = double.tryParse(trimmedValue);
    final proposedQty = _proposedQuantities[binId] ?? 0.0;

    final otherSelectedTotal = _selectedBins
        .asMap()
        .entries
        .where((entry) => entry.key != index)
        .fold<double>(0.0, (sum, entry) => sum + entry.value.selectedQuantity);

    final remainingActual = max(
      0.0,
      widget.params.item.remainingQuantity - otherSelectedTotal,
    );

    double allowedQty = remainingActual;
    if (proposedQty > 0 && proposedQty < allowedQty) {
      allowedQty = proposedQty;
    }

    String? errorMessage;

    if (trimmedValue.isEmpty) {
      setState(() {
        _binFieldErrors.remove(binId);
        _selectedBins[index] = _selectedBins[index].copyWith(
          selectedQuantity: 0.0,
        );
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
        _binFieldErrors[binId] = errorMessage!;
      });
      return;
    }

    setState(() {
      _binFieldErrors.remove(binId);
      _selectedBins[index] = _selectedBins[index].copyWith(
        selectedQuantity: quantity,
      );
    });
  }

  void _removeBin(int index) {
    if (index >= 0 && index < _selectedBins.length) {
      final removedBin = _selectedBins[index];
      _binQuantityControllers[index].dispose();
      _binQuantityFocusNodes[index].dispose();
      setState(() {
        _selectedBins.removeAt(index);
        _binQuantityControllers.removeAt(index);
        _binQuantityFocusNodes.removeAt(index);
        _proposedQuantities.remove(removedBin.id);
        _binFieldErrors.remove(removedBin.id);
      });
    }
  }

  void _appendBin(BinEntity bin, {double? proposedQuantity}) {
    final newBin = bin.copyWith(selectedQuantity: 0.0);
    final quantityController = TextEditingController();
    final quantityFocusNode = FocusNode();

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

    _selectedBins.add(newBin);
    _binQuantityControllers.add(quantityController);
    _binQuantityFocusNodes.add(quantityFocusNode);
    _binFieldErrors.remove(newBin.id);

    if (proposedQuantity != null) {
      _proposedQuantities[newBin.id] = proposedQuantity;
    } else {
      _proposedQuantities.putIfAbsent(newBin.id, () => 0.0);
    }
  }

  Widget _actionButtons() {
    return Row(
      children: [
        //Expanded(flex: 3, child: _cancelButton()),
        //SizedBox(width: 5.w),
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
    return BlocBuilder<PickingBloc, PickingState>(
      builder: (context, state) {
        final isSubmitting = state is CreatePickingLoading;

        return CustomButton(
          text: AppTexts.proceed,
          // icon: Icons.list,
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
            if (_totalSelectedQuantity > widget.params.item.remainingQuantity) {
              CustomToast.error(
                context,
                "Total quantity cannot exceed remaining quantity (${widget.params.item.remainingQuantity.formatWithCommas})",
              );
              return;
            }

            if (_totalSelectedQuantity < widget.params.item.remainingQuantity) {
              CustomToast.error(
                context,
                "Total quantity must equal remaining quantity (${widget.params.item.remainingQuantity.formatWithCommas})",
              );
              return;
            }

            // Create the request
            final request = CreatePickingRequestModel.fromEntities(
              item: widget.params.item,
              selectedPlant: widget.params.plant,
              selectedStorageLocation: widget.params.storageLocation,
              selectedMovementType: widget.params.movementType,
              receivingPlant: widget.params.item.plant,
              receivingStorageLocation: widget.params.item.storageLocation,
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
