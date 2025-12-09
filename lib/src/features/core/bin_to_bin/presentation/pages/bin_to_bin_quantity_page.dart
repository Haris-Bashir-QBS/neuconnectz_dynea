import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/stock_shimmer.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/source_bin_material_listing_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/bin_to_bin_quantity_bottom_sheet_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/destination_bin_selection_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/stock_check/domain/entities/stock_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/widgets/bin_to_bin_quantity_item_card.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_search_field.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/item_listing_header.dart';

class BinToBinQuantityPage extends StatelessWidget {
  final BinToBinQuantityBottomSheetParams params;

  const BinToBinQuantityPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SourceBinMaterialListingBloc>(),
      child: _BinToBinQuantityView(params: params),
    );
  }
}

class _BinToBinQuantityView extends StatefulWidget {
  final BinToBinQuantityBottomSheetParams params;

  const _BinToBinQuantityView({required this.params});

  @override
  State<_BinToBinQuantityView> createState() => _BinToBinQuantityViewState();
}

class _BinToBinQuantityViewState extends State<_BinToBinQuantityView> {
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, FocusNode> _quantityFocusNodes = {};
  final Map<String, bool> _selectedItems = {};
  final Map<String, String?> _fieldErrors = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllMaterials();
  }

  void _loadAllMaterials() {
    context.read<SourceBinMaterialListingBloc>().add(
      LoadSourceBinMaterialsEvent(
        plant: widget.params.plant.code,
        whsCode: widget.params.warehouse.code ?? '',
        storageLocation: widget.params.warehouse.storageLocationCode ?? '',
        storageBin: widget.params.selectedBin.binCode,
        storageType: widget.params.selectedBin.storageType,
        storageSection: widget.params.selectedBin.storageSection,
        searchQuery: null,
        loadAll: true,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _quantityFocusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onItemSelected(String itemId, bool selected) {
    setState(() {
      _selectedItems[itemId] = selected;
      // Initialize controller if not exists
      if (!_quantityControllers.containsKey(itemId)) {
        _quantityControllers[itemId] = TextEditingController();
        _quantityFocusNodes[itemId] = FocusNode();
      }
      if (!selected) {
        _fieldErrors[itemId] = null;
      }
      _validateField(itemId);
    });
  }

  void _onQuantityChanged(String itemId, String value) {
    setState(() {
      _validateField(itemId);
    });
  }

  String? _validateField(String itemId) {
    if ((_selectedItems[itemId] ?? false) == false) {
      _fieldErrors[itemId] = null;
      return null;
    }

    final controller = _quantityControllers[itemId];
    final quantityText = controller?.text.trim() ?? '';

    if (quantityText.isEmpty) {
      _fieldErrors[itemId] = 'Please enter quantity';
      return 'Please enter quantity';
    }

    final quantity = double.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      _fieldErrors[itemId] = 'Please enter a valid quantity';
      return 'Please enter a valid quantity';
    }

    final stock = _getStockById(itemId);
    if (stock != null && quantity > stock.availableStock) {
      _fieldErrors[itemId] = 'Quantity cannot exceed available stock';
      return 'Quantity cannot exceed available stock';
    }

    _fieldErrors[itemId] = null;
    return null;
  }

  StockEntity? _getStockById(String itemId) {
    final state = context.read<SourceBinMaterialListingBloc>().state;
    if (state is SourceBinMaterialListingSuccess) {
      return state.items.firstWhere(
        (item) => item.id == itemId,
        orElse: () => state.items.first,
      );
    }
    return null;
  }

  bool get _hasErrors {
    return _fieldErrors.values.any((error) => error != null);
  }

  bool get _hasSelectedItems {
    return _selectedItems.values.any((selected) => selected == true);
  }

  bool get _canProceed {
    return _hasSelectedItems && !_hasErrors;
  }

  bool get _areAllSelected {
    final state = context.read<SourceBinMaterialListingBloc>().state;
    if (state is SourceBinMaterialListingSuccess) {
      if (state.items.isEmpty) return false;
      return state.items.every((item) => _selectedItems[item.id] == true);
    }
    return false;
  }

  void _toggleSelectAll() {
    final state = context.read<SourceBinMaterialListingBloc>().state;
    if (state is SourceBinMaterialListingSuccess && state.items.isNotEmpty) {
      setState(() {
        final allSelected = _areAllSelected;
        final newSelectionState = !allSelected;

        for (var item in state.items) {
          _selectedItems[item.id] = newSelectionState;

          // Initialize controllers if needed
          if (!_quantityControllers.containsKey(item.id)) {
            _quantityControllers[item.id] = TextEditingController();
            _quantityFocusNodes[item.id] = FocusNode();
          }

          if (newSelectionState) {
            // When selecting all, validate each field
            _validateField(item.id);
          } else {
            // When unselecting all, clear errors
            _fieldErrors[item.id] = null;
          }
        }
      });
    }
  }

  List<Map<String, dynamic>> _getSelectedMaterials() {
    final List<Map<String, dynamic>> materials = [];
    final state = context.read<SourceBinMaterialListingBloc>().state;

    if (state is SourceBinMaterialListingSuccess) {
      for (var item in state.items) {
        if (_selectedItems[item.id] == true) {
          final quantityText = _quantityControllers[item.id]?.text.trim() ?? '';
          final quantity = double.tryParse(quantityText) ?? 0;
          if (quantity > 0) {
            materials.add({'id': item.id, 'quantity': quantity.toInt()});
          }
        }
      }
    }
    return materials;
  }

  Future<void> _handleMoveToDestination() async {
    // Check if any items are selected
    if (!_hasSelectedItems) {
      CustomToast.error(context, 'Please select at least one item');
      return;
    }

    // Validate all selected fields
    bool hasErrors = false;
    String? errorMessage;

    for (var itemId in _selectedItems.keys) {
      if (_selectedItems[itemId] == true) {
        final controller = _quantityControllers[itemId];
        final quantityText = controller?.text.trim() ?? '';

        if (quantityText.isEmpty) {
          hasErrors = true;
          errorMessage = 'Please enter quantity for all selected items';
          break;
        }

        final quantity = double.tryParse(quantityText);
        if (quantity == null || quantity <= 0) {
          hasErrors = true;
          errorMessage = 'Please enter a valid quantity (greater than zero)';
          break;
        }

        final stock = _getStockById(itemId);
        if (stock != null && quantity > stock.availableStock) {
          hasErrors = true;
          errorMessage = 'Quantity cannot exceed proposed quantity';
          break;
        }
      }
    }

    if (hasErrors && errorMessage != null) {
      CustomToast.error(context, errorMessage);
      setState(() {});
      return;
    }

    final selectedMaterials = _getSelectedMaterials();
    if (selectedMaterials.isEmpty) {
      CustomToast.error(
        context,
        'Please enter valid quantities for selected items',
      );
      return;
    }

    // Navigate to destination bin selection page
    final result = await context.pushNamed(
      AppRoutes.destinationBinSelection,
      extra: DestinationBinSelectionPageParams(
        plant: widget.params.plant,
        warehouse: widget.params.warehouse,
        sourceMaterials: selectedMaterials,
        sourceBin: widget.params.selectedBin,
      ),
    );

    // If destination bin was selected, pop back to source listing
    if (result != null && mounted) {
      Navigator.pop(context);
    }
  }

  void _onSearchChanged(String query) {
    context.read<SourceBinMaterialListingBloc>().add(
      LoadSourceBinMaterialsEvent(
        plant: widget.params.plant.code,
        whsCode: widget.params.warehouse.code ?? '',
        storageLocation: widget.params.warehouse.storageLocationCode ?? '',
        storageBin: widget.params.selectedBin.binCode,
        storageType: widget.params.selectedBin.storageType,
        storageSection: widget.params.selectedBin.storageSection,
        searchQuery: query.isEmpty ? null : query,
        loadAll: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.params.selectedBin.binCode),
      body: Column(
        children: [
          CustomSearchField(
            controller: _searchController,
            hint: AppTexts.search,
            onChanged: _onSearchChanged,
          ),

          8.horizontalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            //spacing: 10.h,
            children: [
              CustomText(
                text: 'Select All',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                // color: AppPalette.primaryColor,
              ),
              3.horizontalSpace,
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: _areAllSelected,
                  onChanged: (_) => _toggleSelectAll(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppPalette.primaryColor.withAlpha(150),
                  checkColor: Colors.white,
                ),
              ),
              20.horizontalSpace,
            ],
          ),
          10.verticalSpace,
          _header(),
          10.verticalSpace,
          Expanded(
            child: BlocBuilder<
              SourceBinMaterialListingBloc,
              SourceBinMaterialListingState
            >(
              builder: (context, state) {
                if (state is SourceBinMaterialListingLoading) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 6,
                    itemBuilder: (_, __) => StockCardShimmer(),
                  );
                }

                if (state is SourceBinMaterialListingFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: state.message,
                          fontSize: 14.sp,
                          color: AppPalette.greyColor,
                          textAlign: TextAlign.center,
                        ),
                        12.verticalSpace,
                        ElevatedButton(
                          onPressed: _loadAllMaterials,
                          child: Text(AppTexts.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SourceBinMaterialListingSuccess) {
                  if (state.items.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: AppTexts.noStocksFound,
                        fontSize: 14.sp,
                        color: AppPalette.greyColor,
                      ),
                    );
                  }

                  return Container(
                    color: AppPalette.whiteColor,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        final isSelected = _selectedItems[item.id] ?? false;
                        final error = _fieldErrors[item.id];

                        if (!_quantityControllers.containsKey(item.id)) {
                          _quantityControllers[item.id] =
                              TextEditingController();
                          _quantityFocusNodes[item.id] = FocusNode();
                        }

                        return BinToBinQuantityItemCard(
                          item: item,
                          isSelected: isSelected,
                          error: error,
                          quantityController: _quantityControllers[item.id]!,
                          quantityFocusNode: _quantityFocusNodes[item.id]!,
                          onSelectionChanged:
                              (selected) => _onItemSelected(item.id, selected),
                          onQuantityChanged:
                              (value) => _onQuantityChanged(item.id, value),
                          validator: (value) {
                            if (!isSelected) return null;
                            if (value == null || value.trim().isEmpty) {
                              return null; // Don't show error for empty
                            }
                            final quantity = double.tryParse(value.trim());
                            if (quantity == null || quantity <= 0) {
                              return ' '; // Non-empty string shows red border
                            }
                            final stock = _getStockById(item.id);
                            if (stock != null &&
                                quantity > stock.availableStock) {
                              return ' '; // Non-empty string shows red border
                            }
                            return null; // Valid
                          },
                          maxQuantity: item.availableStock,
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomButton.bordered(
                text: 'Move to Destination Bin',
                trailingIcon: Icons.arrow_forward,
                onPressed: _handleMoveToDestination,
                radius: 12.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 14.h,
        bottom: 16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: CustomText(
              text: 'MAterial No',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.greyColor,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              text: 'Proposed Qty',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.greyColor,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              text: 'Act Qty',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppPalette.greyColor,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
