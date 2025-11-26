import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/pages/grn_listing_page.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/movement_type_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/presentation/blocs/plant_warehouse_bloc.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_dropdown.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/inline_linear_loader.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import '../../../../../widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';

enum SelectionFlow { putAwayAgainstGrn, reservationAgainstPicking }

class WarehouseAndPlantSelectionPage extends StatefulWidget {
  final SelectionFlow flow;

  const WarehouseAndPlantSelectionPage({
    super.key,
    this.flow = SelectionFlow.putAwayAgainstGrn,
  });

  @override
  State<WarehouseAndPlantSelectionPage> createState() =>
      _WarehouseAndPlantSelectionPageState();
}

class _WarehouseAndPlantSelectionPageState
    extends State<WarehouseAndPlantSelectionPage> {
  int currentStep = 0;
  PlantEntity? _selectedPlant;
  WarehouseEntity? _selectedWarehouse;
  MovementTypeEntity? _selectedMovementType;
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
    final isReservationFlow =
        widget.flow == SelectionFlow.reservationAgainstPicking;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackNavigation(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title:
              isReservationFlow
                  ? AppTexts.pickingAgainstReservation
                  : AppTexts.putAwayAgainstGrn,
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

  /// STEP 1: Select Plant, Warehouse and (optionally) Movement Type
  Widget _buildStepOne(BuildContext context, WarehouseAndPlantState state) {
    final isReservationFlow =
        widget.flow == SelectionFlow.reservationAgainstPicking;
    final plants = state.plants;
    final warehouses = state.warehouses;

    final isButtonEnabled =
        _selectedPlant != null &&
        _selectedWarehouse != null &&
        (!isReservationFlow || _selectedMovementType != null);

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
              text:
                  isReservationFlow
                      ? AppTexts.selectPlantWarehouseAndMovementType
                      : AppTexts.selectPlantAndWarehouse,
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
                  if (isReservationFlow) ...[
                    16.verticalSpace,
                    BlocProvider(
                      create:
                          (_) =>
                              sl<MovementTypeBloc>()
                                ..add(const LoadMovementTypesEvent()),
                      child: BlocBuilder<MovementTypeBloc, MovementTypeState>(
                        builder: (context, mState) {
                          final isLoading = mState is MovementTypeLoading;
                          final hasError = mState is MovementTypeFailure;
                          final items =
                              mState is MovementTypeSuccess
                                  ? mState.items
                                  : <MovementTypeEntity>[];

                          if (hasError) {
                            CustomToast.error(context, (mState).message);
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdown<MovementTypeEntity>(
                                hint: AppTexts.selectMovementType,
                                headingText: AppTexts.selectMovementType,
                                items: items,
                                selectedValue: _selectedMovementType,
                                displayItem:
                                    (m) =>
                                        "${m.movementType} - ${m.description}",
                                onChanged:
                                    isLoading
                                        ? null
                                        : (mt) {
                                          setState(
                                            () => _selectedMovementType = mt,
                                          );
                                        },
                              ),
                              if (isLoading) ...[
                                8.verticalSpace,
                                const LinearProgressIndicator(),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
