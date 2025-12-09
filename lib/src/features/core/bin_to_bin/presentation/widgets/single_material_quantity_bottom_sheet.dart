import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/extensions/number_extensions.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/destination_bin_selection_page_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/single_material_quantity_bottom_sheet_params.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';

class SingleMaterialQuantityBottomSheet extends StatefulWidget {
  final SingleMaterialQuantityBottomSheetParams params;

  const SingleMaterialQuantityBottomSheet({super.key, required this.params});

  @override
  State<SingleMaterialQuantityBottomSheet> createState() =>
      _SingleMaterialQuantityBottomSheetState();
}

class _SingleMaterialQuantityBottomSheetState
    extends State<SingleMaterialQuantityBottomSheet> {
  final TextEditingController _actualQuantityController =
      TextEditingController();
  final FocusNode _actualQuantityFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _actualQuantityFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_actualQuantityFocusNode.hasFocus) {
      // Delay to ensure keyboard is fully open
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _actualQuantityFocusNode.removeListener(_onFocusChange);
    _actualQuantityController.dispose();
    _actualQuantityFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Don't show error for empty
    }

    final trimmedValue = value.trim();

    // Check if it's a valid number
    final quantity = double.tryParse(trimmedValue);
    if (quantity == null) {
      return ' '; // Non-empty string shows red border
    }

    // Check if it's zero or negative
    if (quantity <= 0) {
      return ' '; // Non-empty string shows red border
    }

    // Check if it exceeds proposed quantity
    if (quantity > widget.params.stock.availableStock) {
      return ' '; // Non-empty string shows red border
    }

    return null; // Valid
  }

  Future<void> _handleMoveToDestination() async {
    if (!_formKey.currentState!.validate()) {
      // Form validation failed, show appropriate error
      final quantityText = _actualQuantityController.text.trim();

      if (quantityText.isEmpty) {
        CustomToast.error(context, 'Please enter actual quantity');
        return;
      }

      final quantity = double.tryParse(quantityText);
      if (quantity == null) {
        CustomToast.error(context, 'Please enter a valid number');
        return;
      }

      if (quantity <= 0) {
        CustomToast.error(context, 'Quantity must be greater than zero');
        return;
      }

      if (quantity > widget.params.stock.availableStock) {
        CustomToast.error(
          context,
          'Quantity cannot exceed proposed quantity',
        );
        return;
      }
      return;
    }

    final quantityText = _actualQuantityController.text.trim();
    final quantity = double.parse(quantityText);

    // Navigate to destination bin selection
    final result = await context.pushNamed(
      AppRoutes.destinationBinSelection,
      extra: DestinationBinSelectionPageParams(
        plant: widget.params.plant,
        warehouse: widget.params.warehouse,
        sourceMaterials: [
          {'id': widget.params.stock.id, 'quantity': quantity.toInt()},
        ],
        sourceBin: widget.params.sourceBin,
      ),
    );

    // If destination bin was selected, pop back
    if (result != null && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stock = widget.params.stock;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: 20.h + keyboardHeight,
      ),
      decoration: BoxDecoration(
        color: AppPalette.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header with close button
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: AppPalette.darkGreyColor,
                  ),
                ),
                12.horizontalSpace,
                CustomText(
                  text: 'Add Quantity',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.darkGreyColor,
                ),
              ],
            ),
            24.verticalSpace,
            // Material Details Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  _buildReadOnlyField(label: 'Material', value: stock.material),
                  12.verticalSpace,
                  _buildReadOnlyField(
                    label: 'Material Description',
                    value: stock.description,
                  ),
                  12.verticalSpace,
                  _buildReadOnlyField(
                    label: 'Batch Number',
                    value: stock.batch ?? 'N/A',
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            // Quantity Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyField(
                      label: 'Proposed Qty',
                      value: stock.availableStock.formatWithCommas,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: CustomTextFormField(
                      controller: _actualQuantityController,
                      focusNode: _actualQuantityFocusNode,
                      label: 'Actual Quantity',
                      hint: 'e.g 456',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      validator: _validateQuantity,
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            CustomButton(
              text: 'Move to Destination Bin',
              trailingIcon: Icons.arrow_forward,
              onPressed: _handleMoveToDestination,
              radius: 12.r,
            ),
            SafeArea(child: SizedBox(height: 8.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, fontSize: 12.sp, color: AppPalette.greyColor),
        4.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppPalette.lightGreyColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CustomText(
            text: value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.darkGreyColor,
          ),
        ),
      ],
    );
  }
}
