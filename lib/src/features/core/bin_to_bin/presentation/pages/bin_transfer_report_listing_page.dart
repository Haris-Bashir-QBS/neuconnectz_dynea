import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/router/app_routes.dart';
import 'package:neuconnectz_dynea/src/core/utils/date_time_helper.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/entities/bin_transfer_report_entity.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/domain/params/get_bin_transfer_report_params.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_event.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/blocs/bin_transfer_report_state.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/widgets/bin_transfer_report_item_card.dart';
import 'package:neuconnectz_dynea/src/features/core/bin_to_bin/presentation/widgets/bin_transfer_transaction_details_bottom_sheet.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_appbar.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_button.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text_formfield.dart';

import '../../../../../core/router/app_router.dart';

class BinTransferReportListingPage extends StatelessWidget {
  const BinTransferReportListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<BinTransferReportBloc>()..add(
                const LoadBinTransferReportEvent(
                  params: GetBinTransferReportParams(),
                ),
              ),
      child: const _BinTransferReportListingView(),
    );
  }
}

class _BinTransferReportListingView extends StatefulWidget {
  const _BinTransferReportListingView();

  @override
  State<_BinTransferReportListingView> createState() =>
      _BinTransferReportListingViewState();
}

class _BinTransferReportListingViewState
    extends State<_BinTransferReportListingView>
    with RouteAware {
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _dateRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDateRangeText();
  }

  void _updateDateRangeText() {
    if (_fromDate != null && _toDate != null) {
      _dateRangeController.text =
          "${_fromDate!.toString().split(' ').first} - ${_toDate!.toString().split(' ').first}";
    } else {
      _dateRangeController.clear();
    }
  }

  // 🔥 Subscribe RouteAware
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // 🔥 Unsubscribe
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _dateRangeController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    print("Did pop next - reloading report");
    context.read<BinTransferReportBloc>().add(
      const LoadBinTransferReportEvent(params: GetBinTransferReportParams()),
    );
  }

  Future<void> _selectDateRange() async {
    final now = DateTime.now();
    final firstDate = DateTime(2000);
    final lastDate = DateTime(now.year, now.month, now.day);

    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange:
          _fromDate != null && _toDate != null
              ? DateTimeRange(start: _fromDate!, end: _toDate!)
              : null,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        _fromDate = pickedRange.start;
        _toDate = pickedRange.end;
        _updateDateRangeText();
        _loadReport();
      });
    }
  }

  void _resetDateRange() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _dateRangeController.clear();
      _loadReport();
    });
  }

  void _loadReport() {
    final params = GetBinTransferReportParams(
      fromDate:
          _fromDate != null
              ? DateFormat('yyyy-MM-dd').format(_fromDate!)
              : null,
      toDate:
          _toDate != null ? DateFormat('yyyy-MM-dd').format(_toDate!) : null,
    );

    context.read<BinTransferReportBloc>().add(
      LoadBinTransferReportEvent(params: params),
    );
  }

  String _getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  String _getDateString(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date).toUpperCase();
  }

  Map<DateTime, List<BinTransferReportEntity>> _groupReportsByDate(
    List<BinTransferReportEntity> reports,
  ) {
    final grouped = <DateTime, List<BinTransferReportEntity>>{};
    final now = DateTime.now();

    // Since transferDate is not in the API response structure provided,
    // we'll group all reports under current date for now
    // If the API later includes a date field, extract it here
    for (var report in reports) {
      // Using current date as default - adjust when API provides date field
      final dateKey = DateTime(now.year, now.month, now.day);
      grouped.putIfAbsent(dateKey, () => []).add(report);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppTexts.binToBinTransfer),
      body: Column(
        children: [
          _buildDateRangeFilter(),
          Expanded(child: _buildReportList()),
          _buildNewTransferButton(),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppPalette.whiteColor,
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              if (_fromDate != null && _toDate != null)
                GestureDetector(
                  onTap: _resetDateRange,
                  child: Row(
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 18.sp,
                        color: AppPalette.primaryColor,
                      ),
                      4.horizontalSpace,
                      CustomText(
                        text: 'Reset',
                        fontSize: 12.sp,
                        color: AppPalette.primaryColor,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          8.verticalSpace,
          Row(
            children: [
              CustomText(
                text: "Date Range",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              10.horizontalSpace,
              Expanded(
                child: GestureDetector(
                  onTap: _selectDateRange,
                  child: CustomTextFormField(
                    hint: 'Set date range',
                    controller: _dateRangeController,
                    readOnly: true,
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      size: 20.sp,
                      color: AppPalette.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_fromDate != null && _toDate != null) ...[
            8.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppPalette.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8.sp,
                    color: AppPalette.primaryColor,
                  ),
                  8.horizontalSpace,
                  CustomText(
                    text:
                        '${DateFormat('MMM dd, yyyy').format(_fromDate!).toUpperCase()} | ${DateFormat('MMM dd, yyyy').format(_toDate!).toUpperCase()}',
                    fontSize: 12.sp,
                    color: AppPalette.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportList() {
    return BlocBuilder<BinTransferReportBloc, BinTransferReportState>(
      builder: (context, state) {
        if (state is BinTransferReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BinTransferReportFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: state.message,
                  fontSize: 14.sp,
                  color: AppPalette.greyColor,
                ),
                12.verticalSpace,
                ElevatedButton(
                  onPressed: _loadReport,
                  child: Text(AppTexts.retry),
                ),
              ],
            ),
          );
        }

        if (state is BinTransferReportSuccess) {
          if (state.reports.isEmpty) {
            return Center(
              child: CustomText(
                text: 'No bin transfers found',
                fontSize: 14.sp,
                color: AppPalette.greyColor,
              ),
            );
          }

          // Group reports by date
          final grouped = _groupReportsByDate(state.reports);

          return RefreshIndicator(
            onRefresh: () async {
              _loadReport();
              // Wait a bit to allow the refresh indicator to show
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final dateKey = grouped.keys.elementAt(index);
                final reports = grouped[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateHeader(dateKey),
                    4.verticalSpace,
                    ...reports.map(
                      (report) => BinTransferReportItemCard(
                        report: report,
                        onTap: () => _showTransactionDetails(context, report),
                      ),
                    ),
                    16.verticalSpace,
                  ],
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppPalette.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: _getDayOfWeek(date),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.primaryColor,
          ),
          CustomText(
            text: _getDateString(date),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPalette.primaryColor,
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    BinTransferReportEntity report,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BinTransferTransactionDetailsBottomSheet(report: report),
    ).then((result) {
      if (result == 'edit') {
        // Handle edit action
        // TODO: Navigate to edit screen or show edit dialog
      } else if (result == 'delete') {
        // Handle delete action
        // TODO: Show confirmation and delete transfer
      }
    });
  }

  Widget _buildNewTransferButton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomButton(
          text: 'New Bin to Bin Transfer',
          icon: Icons.add,
          onPressed: () {
            context
                .pushNamed(
                  AppRoutes.documentSelection,
                  extra: DocumentSelectionConfigs.binToBin(),
                )
                .then((val) {
                  // Reload report after returning from document selection
                  context.read<BinTransferReportBloc>().add(
                    const LoadBinTransferReportEvent(
                      params: GetBinTransferReportParams(),
                    ),
                  );
                });
          },
          radius: 12.r,
        ),
      ),
    );
  }
}


