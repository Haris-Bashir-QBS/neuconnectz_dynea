import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/constants/asset_paths.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/enums/scan_type.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/utils/utils.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_to_bin_transfer_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_event.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/params/destination_bin_selection_page_params.dart';
import 'package:neuconnectz_dynea/src/shared/bins/domain/entities/bin_entity.dart';
import 'package:neuconnectz_dynea/src/shared/bins/presentation/blocs/bin_bloc.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_toast.dart';
import 'package:neuconnectz_dynea/src/widgets/generic_selection_dialog.dart';
import 'package:neuconnectz_dynea/src/widgets/modal_progress_hud.dart';
import 'package:neuconnectz_dynea/src/widgets/status_dialog.dart';

import '../../../../../core/router/app_routes.dart';

class DestinationBinSelectionPage extends StatelessWidget {
  final DestinationBinSelectionPageParams params;

  const DestinationBinSelectionPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BinBloc>()),
        BlocProvider(create: (_) => sl<BinToBinTransferBloc>()),
      ],
      child: _DestinationBinSelectionView(params: params),
    );
  }
}

class _DestinationBinSelectionView extends StatefulWidget {
  final DestinationBinSelectionPageParams params;

  const _DestinationBinSelectionView({required this.params});

  @override
  State<_DestinationBinSelectionView> createState() =>
      _DestinationBinSelectionViewState();
}

class _DestinationBinSelectionViewState
    extends State<_DestinationBinSelectionView> {
  final _binCodeController = TextEditingController();
  final _binSearchController = TextEditingController();
  final FocusNode _binCodeFocusNode = FocusNode();

  String _binSearchQuery = '';
  BinEntity? _selectedBin;

  // Pagination for bins
  static const int _pageSize = 10;
  int _skipRecords = 0;

  // Local state to manage bin dialog pagination/results
  final List<BinEntity> _dialogBins = [];
  bool _dialogHasMore = false;
  bool _dialogResetPending = false;

  @override
  void dispose() {
    _binCodeController.dispose();
    _binSearchController.dispose();
    _binCodeFocusNode.dispose();
    super.dispose();
  }

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
        warehouseCode: widget.params.warehouse.code,
        storageType: storageType,
        keyword: keyword,
        lastCount: _pageSize,
        skipRecords: _skipRecords,
      ),
    );

    _skipRecords += _pageSize;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BinToBinTransferBloc, BinToBinTransferState>(
      listener: (context, state) {
        if (state is BinToBinTransferSuccess) {
          _showSuccessDialog(context, state);
        } else if (state is BinToBinTransferFailure) {
          CustomToast.error(context, state.message);
        }
      },
      child: BlocBuilder<BinToBinTransferBloc, BinToBinTransferState>(
        builder: (context, transferState) {
          return ModalProgressHUD(
            inAsyncCall: transferState is BinToBinTransferLoading,
            child: Scaffold(
              appBar: const CustomAppBar(title: AppTexts.binToBinTransfer),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Select & Scan Destination Bin",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                            SizedBox(height: 10.h),
                            _binSelectionSection(),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedBin != null)
                      Container(
                        padding: EdgeInsets.all(20.w),
                        color: AppPalette.whiteColor,
                        child: _actionButtons(),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, BinToBinTransferSuccess state) {
    AnimatedStatusDialog.show(
      context: context,
      isSuccess: true,
      title: AppTexts.success,
      message: state.response.message,
      primaryButtonText: AppTexts.continuee,
      onPrimaryTap: () {
        // Pop the dialog first
        Navigator.pop(context);

        _navigateToReportScreen(context);
      },
    );
  }

  void _navigateToReportScreen(BuildContext context) {
    if (mounted) {
      // Try to pop until report screen
      bool foundReportScreen = false;
      Navigator.popUntil(context, (route) {
        if (route.settings.name == AppRoutes.binTransferReportListing) {
          foundReportScreen = true;
          return true;
        }
        return false;
      });

      // If report screen is not in the stack, navigate to it
      if (!foundReportScreen && mounted) {
        context.goNamed(AppRoutes.binTransferReportListing);
      }
    }
  }

  Widget _binSelectionSection() {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400.w),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: AppPalette.lightGreyColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(Icons.warehouse),
              ),
            ),
            SizedBox(height: 12.h),
            CustomText(
              text: "Select, Scan & Type Destination Bin",
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text:
                  "Tap the select bin section below to choose bin & view list accordingly.",
              fontSize: 12.sp,
              color: AppPalette.darkGreyColor,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            _binCodeNumberTextField(),
            SizedBox(height: 16.h),
            CustomButton.bordered(
              text: "Scan Destination Storage Bin",
              iconWidget: Image.asset(
                AppAssets.scanIcon,
                color: context.primaryColor,
                width: 20.w,
                height: 20.w,
              ),
              onPressed: () async {
                await openScanner(scanType: FieldScanType.barcode);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _binCodeNumberTextField() {
    // Update controller text when bin is selected
    if (_selectedBin != null &&
        _binCodeController.text != _selectedBin!.binCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _binCodeController.text = _selectedBin!.binCode;
        }
      });
    }

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
      suffixIcon:
          _selectedBin != null
              ? IconButton(
                icon: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppPalette.lightGreyColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.clear,
                    color: AppPalette.darkGreyColor,
                    size: 16.sp,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedBin = null;
                    _binCodeController.clear();
                  });
                },
              )
              : null,
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
      builder:
          (context) => BlocProvider.value(
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
                  },
                  hasMore: _dialogHasMore,
                  onPaginate:
                      _dialogHasMore
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
    // Validate that destination bin is not the same as source bin
    if (_isSameAsSourceBin(bin)) {
      CustomToast.error(
        context,
        'Destination bin cannot be the same as source bin. Please select a different bin.',
      );
      return;
    }

    setState(() {
      _selectedBin = bin;
      _binCodeController.text = bin.binCode;
    });
  }

  bool _isSameAsSourceBin(BinEntity destinationBin) {
    final sourceBin = widget.params.sourceBin;

    /// Three makes a unique combination
    return destinationBin.binCode == sourceBin.binCode &&
        destinationBin.storageSection == sourceBin.storageSection &&
        destinationBin.storageType == sourceBin.storageType;
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
    final isProceedEnabled = _selectedBin != null;

    return CustomButton(
      text: AppTexts.proceed,
      onPressed: isProceedEnabled ? _handleProceed : () {},
      radius: 12.r,
    );
  }

  void _handleProceed() {
    if (_selectedBin == null) {
      CustomToast.error(context, "Please select a destination bin to proceed.");
      return;
    }

    // Show confirmation dialog using AnimatedStatusDialog
    AnimatedStatusDialog.show(
      context: context,
      isSuccess: false,
      title: AppTexts.areYouSure,
      message:
          'Are you sure you want to proceed bin to bin process? Tap proceed to post or edit to make changes.',
      secondaryButtonText: 'Edit',
      onSecondaryTap: () {
        // Just close dialog, user can make changes
      },
      primaryButtonText: AppTexts.proceed,
      onPrimaryTap: () {
        _processTransfer();
      },
    );
  }

  void _processTransfer() {
    if (_selectedBin == null) return;

    context.read<BinToBinTransferBloc>().add(
      ProcessBinToBinTransferEvent(
        plant: widget.params.plant.code,
        warehouseNumber: widget.params.warehouse.code,
        storageLocation: widget.params.warehouse.storageLocationCode ?? '',
        destinationStorageBin: _selectedBin!.binCode,
        destinationStorageType: _selectedBin!.storageType,
        destinationStorageSection: _selectedBin!.storageSection,
        sourceMaterials: widget.params.sourceMaterials,
      ),
    );
  }
}
