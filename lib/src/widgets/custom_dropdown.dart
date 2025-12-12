import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';

import '../core/constants/app_texts.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hint;
  final List<T> items;
  final T? selectedValue;
  final String? headingText;
  final Key? dropdownKey;
  final Future<bool> Function(T?, T?)? onBeforeChange;
  final bool? showHeading;
  final void Function(T?)? onChanged;
  final String Function(T) displayItem;
  final String Function(T)? subtitleBuilder;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.hint,
    this.showHeading = true,
    required this.items,
    required this.onChanged,
    required this.displayItem,
    this.subtitleBuilder,
    this.selectedValue,
    this.headingText,
    this.dropdownKey,
    this.onBeforeChange,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeading!) ...[
          CustomText(
            text: headingText ?? "",
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: AppPalette.darkGreyColor,
          ),
          7.verticalSpace,
        ],
        Row(
          children: [
            Expanded(
              child: DropdownSearch<T>(
                validator: validator,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                suffixProps: DropdownSuffixProps(
                  dropdownButtonProps: DropdownButtonProps(
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                    ),
                    iconClosed: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppPalette.greyColor,
                      size: 36.sp,
                    ),
                    iconOpened: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: AppPalette.greyColor,
                      size: 36.sp,
                    ),
                  ),
                  clearButtonProps: const ClearButtonProps(isVisible: false),
                ),

                // ----------------------------
                // POPUP ITEM BUILDER (with subtitle)
                // ----------------------------
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isDisabled, isSelected) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        displayItem(item),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      subtitle:
                          subtitleBuilder != null
                              ? Text(
                                subtitleBuilder!(item),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppPalette.greyColor,
                                ),
                              )
                              : null,
                    );
                  },
                  showSearchBox: (items.isNotEmpty && items.length > 1),
                  scrollbarProps: ScrollbarProps(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thumbColor: Colors.grey,
                  ),
                  menuProps: buildMenuProps(),
                  searchDelay: Duration(milliseconds: 200),
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 250.h),
                  suggestedItemProps: SuggestedItemProps(),
                  searchFieldProps: buildTextFieldProps(),
                  containerBuilder: containerBuilder,
                ),

                // How selected item appears in closed dropdown
                dropdownBuilder: (context, selectedItem) {
                  if (selectedItem == null) {
                    return SizedBox();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayItem(selectedItem),
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      if (subtitleBuilder != null)
                        Text(
                          subtitleBuilder!(selectedItem),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppPalette.greyColor,
                          ),
                        ),
                    ],
                  );
                },

                items: (filter, infiniteScrollProps) => items,
                itemAsString: displayItem,
                onChanged: onChanged,
                onBeforeChange: onBeforeChange,
                enabled: items.isNotEmpty,
                selectedItem: selectedValue,
                compareFn: (item, selectedItem) {
                  if (item == null || selectedItem == null) return false;
                  return displayItem(item) == displayItem(selectedItem);
                },
                clickProps: ClickProps(),
                filterFn: (item, filter) {
                  return displayItem(
                    item,
                  ).toLowerCase().contains(filter.toLowerCase());
                },
                decoratorProps: buildDropDownDecoratorProps(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget containerBuilder(ctx, popupWidget) {
    double radius = 10;
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppPalette.lightGreyColor, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: popupWidget,
      ),
    );
  }

  MenuProps buildMenuProps() {
    return MenuProps(
      backgroundColor: Colors.transparent,
      positionCallback: positionCallBack,
    );
  }

  RelativeRect positionCallBack(RenderBox dropdownBox, RenderBox overlay) {
    final Offset dropdownOffset = dropdownBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size dropdownSize = dropdownBox.size;
    final Size overlaySize = overlay.size;

    const double verticalSpacing = 6;

    return RelativeRect.fromLTRB(
      dropdownOffset.dx,
      dropdownOffset.dy + dropdownSize.height + verticalSpacing,
      overlaySize.width - dropdownOffset.dx - dropdownSize.width,
      overlaySize.height -
          dropdownOffset.dy -
          dropdownSize.height -
          verticalSpacing,
    );
  }

  TextFieldProps buildTextFieldProps() {
    return TextFieldProps(
      decoration: InputDecoration(
        hintText: AppTexts.search,
        contentPadding: EdgeInsets.symmetric(
          vertical: 4.h,
        ).copyWith(left: 10.w),
        hintStyle: TextStyle(color: AppPalette.hintColor, fontSize: 15.sp),
        border: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(),
      ),
    );
  }

  DropDownDecoratorProps buildDropDownDecoratorProps() {
    return DropDownDecoratorProps(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppPalette.hintColor, fontSize: 15.sp),
        border: buildOutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppPalette.lightGreyColor),
    );
  }
}


