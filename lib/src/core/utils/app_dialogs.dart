import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';

class AppDialogs {
  static Future<void> showSearchDialog({
    required BuildContext context,
    required String title,
    required List<String> items,
    required ValueChanged<String> onItemSelected,
  }) async {
    TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(items);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(hintText: "Search..."),
                    onChanged: (value) {
                      setDialogState(() {
                        filteredItems =
                            items
                                .where(
                                  (item) => item.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ),
                                )
                                .toList();
                      });
                    },
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 250.h,
                    width: double.maxFinite,
                    child:
                        filteredItems.isEmpty
                            ? const Center(child: Text("No results found"))
                            : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: AppPalette.lightGreyColor,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    title: Text(filteredItems[index]),
                                    onTap: () {
                                      onItemSelected(filteredItems[index]);
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
