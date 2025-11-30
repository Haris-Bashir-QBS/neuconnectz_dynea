import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/domain/entities/movement_type_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/reservation/presentation/blocs/movement_type_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/plant_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/entities/warehouse_entity.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/params/plant_warehouse_params.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/presentation/blocs/plant_warehouse_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_dropdown.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/inline_linear_loader.dart';

import '../../../widgets/custom_appbar.dart';

class DocumentSelectionPage extends StatelessWidget {
  const DocumentSelectionPage({super.key, required this.params});

  final DocumentSelectionParams params;

  @override
  Widget build(BuildContext context) {
    Widget view = _DocumentSelectionView(params: params);

    if (params.requiresMovementType) {
      view = BlocProvider(
        create:
            (_) => sl<MovementTypeBloc>()..add(const MovementTypeFetchEvent()),
        child: view,
      );
    }

    return view;
  }
}

class _DocumentSelectionView extends StatefulWidget {
  const _DocumentSelectionView({required this.params});

  final DocumentSelectionParams params;

  @override
  State<_DocumentSelectionView> createState() => _DocumentSelectionViewState();
}

class _DocumentSelectionViewState extends State<_DocumentSelectionView> {
  PlantEntity? _selectedPlant;
  WarehouseEntity? _selectedWarehouse;
  MovementTypeEntity? _selectedMovementType;

  @override
  void initState() {
    super.initState();

    context.read<PlantWarehouseBloc>().add(const LoadPlantsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final requiresMovementType = widget.params.requiresMovementType;
    final isScaffold = widget.params.isScaffold;

    final body = Stack(
      children: [
        BlocConsumer<PlantWarehouseBloc, WarehouseAndPlantState>(
          listener: (context, state) {
            if (state.hasError) {
              CustomToast.error(context, state.errorMessage ?? '');
            }
          },
          builder:
              (context, state) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: _buildForm(state, requiresMovementType),
              ),
        ),
        BlocBuilder<PlantWarehouseBloc, WarehouseAndPlantState>(
          builder:
              (context, state) =>
                  InlineLinearLoader(isVisible: state.isLoading),
        ),
      ],
    );

    if (!isScaffold) {
      return body;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.params.title,
        onTapLeading: () => Navigator.of(context).pop(),
      ),
      body: body,
    );
  }

  Widget _buildForm(WarehouseAndPlantState state, bool requiresMovementType) {
    final isButtonEnabled =
        _selectedPlant != null &&
        _selectedWarehouse != null &&
        (!requiresMovementType || _selectedMovementType != null);

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
        if (requiresMovementType) {
          context.read<MovementTypeBloc>().add(const MovementTypeFetchEvent());
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            CustomText(
              text:
                  requiresMovementType
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
                  _plantSelectionDropdown(state),
                  16.verticalSpace,
                  _warehouseSelectionDropdown(state),
                  if (requiresMovementType) ...[
                    16.verticalSpace,
                    _movementTypeDropdown(),
                  ],
                ],
              ),
            ),
            34.verticalSpace,
            CustomButton.bordered(
              icon: Icons.arrow_forward_rounded,
              onPressed: isButtonEnabled ? _handleSubmit : _showValidationError,
              text: AppTexts.apply,
            ),
          ],
        ),
      ),
    );
  }

  CustomDropdown<PlantEntity> _plantSelectionDropdown(
    WarehouseAndPlantState state,
  ) {
    return CustomDropdown<PlantEntity>(
      hint: AppTexts.selectPlant,
      headingText: AppTexts.selectPlant,
      items: state.plants,
      selectedValue: _selectedPlant,
      displayItem: (plant) => plant.name,
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
    );
  }

  CustomDropdown<WarehouseEntity> _warehouseSelectionDropdown(
    WarehouseAndPlantState state,
  ) {
    return CustomDropdown<WarehouseEntity>(
      hint: AppTexts.selectWarehouse,
      headingText: AppTexts.selectWarehouse,
      items: state.warehouses,
      selectedValue: _selectedWarehouse,
      displayItem: (warehouse) => warehouse.name,
      subtitleBuilder:
          (warehouse) => 'Slc Code: ${warehouse.storageLocationCode ?? '-'}',
      onChanged: (warehouse) => setState(() => _selectedWarehouse = warehouse),
    );
  }

  Widget _movementTypeDropdown() {
    return BlocBuilder<MovementTypeBloc, MovementTypeState>(
      builder: (context, state) {
        return CustomDropdown<MovementTypeEntity>(
          hint: AppTexts.movementType,
          headingText: AppTexts.selectMovementType,
          items: state.items,
          displayItem: (mt) => mt.movementType,
          subtitleBuilder: (mt) => mt.description,
          selectedValue: _selectedMovementType,
          onChanged:
              (movementType) =>
                  setState(() => _selectedMovementType = movementType),
        );
      },
    );
  }

  void _showValidationError() {
    CustomToast.error(context, AppTexts.selectAllFieldsToProceed);
  }

  void _handleSubmit() {
    if (_selectedPlant == null || _selectedWarehouse == null) {
      return _showValidationError();
    }
    if (widget.params.requiresMovementType && _selectedMovementType == null) {
      CustomToast.error(context, AppTexts.selectMovementType);
      return;
    }

    final args = widget.params.destination.buildArgs(
      plant: _selectedPlant!,
      warehouse: _selectedWarehouse!,
      movementType: _selectedMovementType,
    );
    context.pushNamed(widget.params.destination.routeName, extra: args);
  }
}
