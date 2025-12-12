import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';

import '../../../core/constants/app_palette.dart';
import '../../../widgets/custom_text.dart';

class ExpandableListTile extends StatefulWidget {
  final String title;
  final List<SubModuleItem>? items;
  final Widget? leading;
  final Icon? trailingIcon;
  final bool showTrailing;
  final bool shouldNavigateDirectly;
  final VoidCallback? onDirectTap;
  final void Function(String)? onItemTap;
  final void Function(String)? onSubItemTap;

  const ExpandableListTile({
    super.key,
    required this.title,
    this.items,
    this.leading,
    this.trailingIcon,
    this.showTrailing = true,
    this.shouldNavigateDirectly = false,
    this.onDirectTap,
    this.onItemTap,
    this.onSubItemTap,
  });

  @override
  State<ExpandableListTile> createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  final Map<String, bool> _subItemExpanded = {};

  late AnimationController _controller;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.shouldNavigateDirectly) {
      widget.onDirectTap?.call();
    } else {
      setState(() => _isExpanded = !_isExpanded);
      _isExpanded ? _controller.forward() : _controller.reverse();
    }
  }

  void _handleSubItemTap(SubModuleItem item) {
    if (item.subSubItems.isNotEmpty) {
      // If sub-item has sub-sub-items, toggle expansion
      setState(() {
        _subItemExpanded[item.title] = !(_subItemExpanded[item.title] ?? false);
      });
    } else {
      // If no sub-sub-items, call the onItemTap
      widget.onItemTap?.call(item.title);
      setState(() {
        _isExpanded = false;
        _controller.reverse();
      });
    }
  }

  void _handleSubSubItemTap(String subItemTitle, String subSubItemTitle) {
    widget.onSubItemTap?.call(subSubItemTitle);
    setState(() {
      _isExpanded = false;
      _controller.reverse();
      _subItemExpanded.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16.r);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Column(
          children: [
            GestureDetector(
              onTap: _handleTap,
              child: Material(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  leading: widget.leading,
                  title: CustomText(
                    text: widget.title,
                    color: AppPalette.darkGreyColor,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  trailing:
                      widget.showTrailing
                          ? widget.trailingIcon ??
                              ((widget.items?.isEmpty ?? true)
                                  ? const Icon(
                                    Icons.arrow_right_outlined,
                                    size: 24,
                                    // color: Colors.grey,
                                  )
                                  : RotationTransition(
                                    turns: _arrowAnimation,
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: const Icon(
                                        Icons.arrow_right_outlined,
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ))
                          : null,
                ),
              ),
            ),
            _isExpanded ? 3.verticalSpace : 0.verticalSpace,
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: ConstrainedBox(
                constraints:
                    _isExpanded
                        ? const BoxConstraints()
                        : const BoxConstraints(maxHeight: 0),
                child: Column(
                  children: [
                    ...?widget.items?.map(
                      (item) => Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Material(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: () => _handleSubItemTap(item),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 11.h,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // if (item.iconPath != null &&
                                      //     item.iconPath!.isNotEmpty)
                                      //   Container(
                                      //     decoration: BoxDecoration(
                                      //       color: AppPalette.lightGreyColor,
                                      //       shape: BoxShape.circle,
                                      //     ),
                                      //     padding: const EdgeInsets.all(10),
                                      //     child: Image.asset(
                                      //       item.iconPath!,
                                      //       width: 16.w,
                                      //       height: 16.w,
                                      //     ),
                                      //   ),
                                      // if (item.iconPath != null &&
                                      //     item.iconPath!.isNotEmpty)
                                      //   SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: item.title,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            if (item.subtitle.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2.h,
                                                ),
                                                child: CustomText(
                                                  text: item.subtitle,
                                                  fontSize: 14.sp,
                                                  color: AppPalette.greyColor,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (item.subSubItems.isNotEmpty)
                                        AnimatedRotation(
                                          turns:
                                              _subItemExpanded[item.title] ==
                                                      true
                                                  ? 0.25
                                                  : 0,
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10.h),
                                            child: const Icon(
                                              Icons.arrow_right_outlined,
                                              size: 20,
                                              color: AppPalette.darkGreyColor,
                                              //    color: AppPalette.greyColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Sub-sub-items
                          if (item.subSubItems.isNotEmpty)
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: ConstrainedBox(
                                constraints:
                                    (_subItemExpanded[item.title] ?? false)
                                        ? const BoxConstraints()
                                        : const BoxConstraints(maxHeight: 0),
                                child: Column(
                                  children: [
                                    ...item.subSubItems.map(
                                      (subSubItem) => Padding(
                                        padding: EdgeInsets.only(
                                          left: 0.w,
                                          right: 0.w,
                                          top: 2.h,
                                          bottom: 2.h,
                                        ),
                                        child: Material(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            onTap:
                                                () => _handleSubSubItemTap(
                                                  item.title,
                                                  subSubItem.title,
                                                ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // if (subSubItem.iconPath !=
                                                  //         null &&
                                                  //     subSubItem
                                                  //         .iconPath!
                                                  //         .isNotEmpty)
                                                  //   Container(
                                                  //     decoration: BoxDecoration(
                                                  //       color:
                                                  //           AppPalette
                                                  //               .lightGreyColor,
                                                  //       shape: BoxShape.circle,
                                                  //     ),
                                                  //     padding:
                                                  //         const EdgeInsets.all(
                                                  //           8,
                                                  //         ),
                                                  //     child: Image.asset(
                                                  //       subSubItem.iconPath!,
                                                  //       width: 14.w,
                                                  //       height: 14.w,
                                                  //     ),
                                                  //   ),
                                                  // if (subSubItem.iconPath !=
                                                  //         null &&
                                                  //     subSubItem
                                                  //         .iconPath!
                                                  //         .isNotEmpty)
                                                  //   SizedBox(width: 10.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomText(
                                                          text:
                                                              subSubItem.title,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        if (subSubItem
                                                            .subtitle
                                                            .isNotEmpty)
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  top: 2.h,
                                                                ),
                                                            child: CustomText(
                                                              text:
                                                                  subSubItem
                                                                      .subtitle,
                                                              fontSize: 13.sp,
                                                              color:
                                                                  AppPalette
                                                                      .greyColor,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
