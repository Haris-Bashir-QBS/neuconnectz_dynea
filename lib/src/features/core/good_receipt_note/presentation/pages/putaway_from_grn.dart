import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
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

class PutAwayFromGrn extends StatefulWidget {
  const PutAwayFromGrn({super.key});

  @override
  State<PutAwayFromGrn> createState() => _PutAwayFromGrnState();
}

class _PutAwayFromGrnState extends State<PutAwayFromGrn> {
  int currentStep = 0;
  PlantEntity? _selectedPlant;
  WarehouseEntity? _selectedWarehouse;

  @override
  void initState() {
    final bloc = context.read<PlantWarehouseBloc>();
    bloc
      ..add(const LoadPlantsEvent())
      ..add(const LoadWarehousesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (currentStep > 0) {
          setState(() {
            currentStep--;
          });
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: AppTexts.putAwayFromGr),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: BlocConsumer<PlantWarehouseBloc, WarehouseAndPlantState>(
                listener: (context, state) {
                  if (state.hasError) {
                    CustomToast.error(context, state.errorMessage ?? "");
                  }
                },
                builder: (context, state) {
                  if (currentStep == 0) {
                    return _buildStepOne(context, state);
                  } else if (currentStep == 1) {
                    return _buildStepTwo(context);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
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

  /// STEP 1: Select Plant and Warehouse
  Widget _buildStepOne(BuildContext context, WarehouseAndPlantState state) {
    final plants = state.plants;
    final warehouses = state.warehouses;

    final isButtonEnabled =
        _selectedPlant != null && _selectedWarehouse != null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScannerAndAutoScanToggleWidget(
            isScannerConnected: false,
            isAutoScan: false,
            onScannerConnectedChanged: (_) {},
            onAutoScanChanged: (_) {},
          ),
          16.verticalSpace,
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
                          params: WarehouseQueryParams(plantId: plant.id),
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
                  onChanged: (wh) {
                    setState(() => _selectedWarehouse = wh);
                  },
                ),
              ],
            ),
          ),
          64.verticalSpace,
          CustomButton.bordered(
            icon: Icons.arrow_forward_rounded,
            onPressed:
                isButtonEnabled ? () => setState(() => currentStep = 1) : () {},
            text: AppTexts.apply,
          ),
        ],
      ),
    );
  }

  /// STEP 2: Next step after selecting Plant & Warehouse
  Widget _buildStepTwo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        32.verticalSpace,
        CustomText(
          text:
              'Step 2 - Proceed with Put Away Process for\n${_selectedWarehouse?.name ?? ''}',
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        CustomButton.bordered(
          text: 'Back to Step 1',
          onPressed: () => setState(() => currentStep = 0),
        ),
      ],
    );
  }
}
