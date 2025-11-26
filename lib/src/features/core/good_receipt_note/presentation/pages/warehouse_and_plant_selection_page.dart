import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/grn_listing_page.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/presentation/blocs/plant_warehouse_bloc.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_dropdown.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/inline_linear_loader.dart';
import 'package:neuconnectz_dynea/src/widgets/scanner_and_auto_scan_toggle_widgets.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import '../../../../../widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';

class WarehouseAndPlantSelectionPage extends StatefulWidget {
  const WarehouseAndPlantSelectionPage({super.key});

  @override
  State<WarehouseAndPlantSelectionPage> createState() =>
      _WarehouseAndPlantSelectionPageState();
}

class _WarehouseAndPlantSelectionPageState
    extends State<WarehouseAndPlantSelectionPage> {
  int currentStep = 0;
  PlantEntity? _selectedPlant;
  WarehouseEntity? _selectedWarehouse;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final bloc = context.read<PlantWarehouseBloc>();
    bloc.add(const LoadPlantsEvent());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackNavigation(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppTexts.putAwayAgainstGrn,
          onTapLeading: () {
            _handleBackNavigation(context);
          },
        ),
        body: Stack(
          children: [
            BlocConsumer<PlantWarehouseBloc, WarehouseAndPlantState>(
              listener: (context, state) {
                if (state.hasError) {
                  CustomToast.error(context, state.errorMessage ?? "");
                }
              },
              builder: (context, state) {
                if (currentStep == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: _buildStepOne(context, state),
                  );
                } else if (currentStep == 1) {
                  return _buildStepTwo(context);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            BlocBuilder<PlantWarehouseBloc, WarehouseAndPlantState>(
              builder: (context, state) {
                return InlineLinearLoader(isVisible: state.isLoading);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  /// STEP 1: Select Plant and Warehouse
  Widget _buildStepOne(BuildContext context, WarehouseAndPlantState state) {
    final plants = state.plants;
    final warehouses = state.warehouses;

    final isButtonEnabled =
        _selectedPlant != null && _selectedWarehouse != null;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PlantWarehouseBloc>().add(const LoadPlantsEvent());
        if (_selectedPlant != null) {
          context.read<PlantWarehouseBloc>().add(
            SelectPlantEvent(
              params: WarehouseQueryParams(plantCode: _selectedPlant!.code),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            // ScannerAndAutoScanToggleWidget(
            //   isScannerConnected: false,
            //   isAutoScan: false,
            //   onScannerConnectedChanged: (_) {},
            //   onAutoScanChanged: (_) {},
            // ),
            //16.verticalSpace,
            CustomText(
              text: AppTexts.selectPlantAndWarehouse,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
            12.verticalSpace,
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdown<PlantEntity>(
                    hint: AppTexts.selectPlant,
                    headingText: AppTexts.selectPlant,
                    items: plants,
                    selectedValue: _selectedPlant,
                    displayItem: (p) => p.name,
                    onChanged: (plant) {
                      setState(() {
                        _selectedPlant = plant;
                        _selectedWarehouse = null;
                      });
                      if (plant != null) {
                        context.read<PlantWarehouseBloc>().add(
                          SelectPlantEvent(
                            params: WarehouseQueryParams(plantCode: plant.code),
                          ),
                        );
                      }
                    },
                  ),
                  16.verticalSpace,
                  CustomDropdown<WarehouseEntity>(
                    hint: AppTexts.selectWarehouse,
                    headingText: AppTexts.selectWarehouse,
                    items: warehouses,
                    selectedValue: _selectedWarehouse,
                    displayItem: (w) => w.name,
                    subtitleBuilder:
                        (w) => "SLC Code: ${w.storageLocationCode ?? ""}",
                    onChanged: (wh) {
                      setState(() => _selectedWarehouse = wh);
                    },
                  ),
                ],
              ),
            ),
            34.verticalSpace,
            CustomButton.bordered(
              icon: Icons.arrow_forward_rounded,
              onPressed:
                  isButtonEnabled
                      ? () => setState(() => currentStep = 1)
                      : () {
                        CustomToast.error(
                          context,
                          "Please select both Plant and Warehouse to proceed.",
                        );
                      },
              text: AppTexts.apply,
            ),
          ],
        ),
      ),
    );
  }

  /// STEP 2: Next step after selecting Plant & Warehouse
  Widget _buildStepTwo(BuildContext context) {
    if (_selectedPlant == null || _selectedWarehouse == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (context) => sl<GrnBloc>(),
      child: GrnListingPage(
        selectedPlant: _selectedPlant!,
        selectedWarehouse: _selectedWarehouse!,
        scrollController: _scrollController,
      ),
    );
  }
}
