import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_errors.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/shimmers/dialog_listview_shimmer.dart';
import 'custom_text.dart';

class GenericSelectionDialog<T> extends StatefulWidget {
  final List<T> items;
  final Function(T) onSelected;
  final TextEditingController controller;
  final bool? loading;
  final void Function(String)? onChanged;
  final String? barcode;
  final Widget Function(T item)? titleBuilder;
  final Widget Function(T item)? subTitleBuilder;
  final String searchLabel;
  final String? noDataText;
  final Widget? child;
  final Widget? chipWidget;
  final Future<void> Function()? onRefresh;
  final String? headingText;
  final bool? showTrailingWidgetInShimmer;
  final ScrollController? scrollController;
  final VoidCallback? onPaginate;
  final bool? hasMore;

  /// ⭐ New table support
  final bool isTable;
  final List<String>? tableHeaders;
  final List<String> Function(T item)? tableRowBuilder;

  const GenericSelectionDialog({
    super.key,
    required this.items,
    required this.onSelected,
    required this.controller,
    required this.searchLabel,
    this.loading = true,
    this.titleBuilder,
    this.subTitleBuilder,
    this.noDataText,
    this.onRefresh,
    this.onChanged,
    this.barcode,
    this.child,
    this.hasMore,
    this.chipWidget,
    this.showTrailingWidgetInShimmer,
    this.onPaginate,
    this.scrollController,
    this.headingText,

    /// new params
    this.isTable = false,
    this.tableHeaders,
    this.tableRowBuilder,
  });

  @override
  State<GenericSelectionDialog<T>> createState() =>
      _GenericSelectionDialogState<T>();
}

class _GenericSelectionDialogState<T> extends State<GenericSelectionDialog<T>> {
  final ScrollController scrollControllerLocal = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    // widget.controller.clear();
    super.initState();
    scrollControllerLocal.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollControllerLocal.position.pixels ==
            scrollControllerLocal.position.maxScrollExtent &&
        widget.loading != true) {
      widget.onPaginate?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.9.sw,
          maxHeight: 0.7.sh,
          minHeight: 0.4.sh,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleWidget(),
              SizedBox(height: 16.h),
              _searchTextField(),
              SizedBox(height: 12.h),
              if (widget.chipWidget != null) ...[
                widget.chipWidget!,
                5.verticalSpace,
              ],
              widget.child ?? const SizedBox.shrink(),

              /// ⭐ Table Header
              if (widget.isTable &&
                  widget.tableHeaders != null &&
                  widget.loading != true)
                _tableHeader(),

              _detailsWidget(),
              SizedBox(height: 12.h),
              _closeButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsWidget() {
    return Expanded(
      child:
          widget.loading!
              ? _shimmer()
              : widget.items.isNotEmpty
              ? _itemsListView()
              : _noDataFoundWidget(),
    );
  }

  RefreshIndicator _noDataFoundWidget() {
    return RefreshIndicator(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 0.46.sh,
            child: Center(
              child: CustomText(
                text: widget.noDataText ?? AppErrors.noItemsFound,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer() {
    return DialogShimmerListView(
      showTrailingWidget: widget.showTrailingWidgetInShimmer,
    );
  }

  Widget _closeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _titleWidget() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        widget.headingText ?? 'Select Item',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ⭐ Table header UI
  Widget _tableHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Row(
        children:
            widget.tableHeaders!
                .map(
                  (h) => Expanded(
                    child: Text(
                      h,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _itemsListView() {
    return ListView.separated(
      controller: scrollControllerLocal,
      itemCount:
          (widget.loading! || widget.hasMore == true)
              ? widget.items.length + 1
              : widget.items.length,
      itemBuilder: (_, index) {
        if (index == widget.items.length) {
          return _bottomLoader();
        }

        final item = widget.items[index];

        return GestureDetector(
          onTap: () => widget.onSelected(item),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(6),
            ),
            child:
                widget.isTable
                    ? _tableRow(item)
                    : ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CustomText(
                        text: "${index + 1}",
                        fontSize: 18.sp,
                      ),
                      title: widget.titleBuilder!(item),
                      trailing: widget.subTitleBuilder!(item),
                    ),
          ),
        );
      },
      separatorBuilder: (_, __) => 6.verticalSpace,
    );
  }

  /// ⭐ Table row UI
  Widget _tableRow(T item) {
    final rowData = widget.tableRowBuilder!(item);

    return Row(
      children:
          rowData
              .map(
                (val) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: Text(val, style: TextStyle(fontSize: 14.sp)),
                  ),
                ),
              )
              .toList(),
    );
  }

  Padding _bottomLoader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Transform.scale(
          scale: 0.9,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return TextFormField(
      controller: widget.controller,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: widget.searchLabel,
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            widget.controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged?.call("");
                  },
                )
                : null,
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 450), () {
      widget.onChanged?.call(value);
    });
  }

  @override
  void dispose() {
    scrollControllerLocal.removeListener(_scrollListener);
    _debounce?.cancel();
    super.dispose();
  }
}
