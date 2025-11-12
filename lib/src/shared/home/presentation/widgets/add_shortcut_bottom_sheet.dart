// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
// import 'package:neuconnectz_dynea/src/core/models/dashboard_component_model.dart';
// import 'package:neuconnectz_dynea/src/widgets/custom_text.dart';
//
// import '../../../../../core/constants/app_palette.dart' show AppPalette;
// import '../../../../../core/constants/app_texts.dart';
// import '../../../../../widgets/custom_button.dart' show CustomButton;
// import '../blocs/home_bloc.dart';
//
// class AddShortcutBottomSheet extends StatefulWidget {
//   const AddShortcutBottomSheet({super.key});
//
//   @override
//   State<AddShortcutBottomSheet> createState() => _AddShortcutBottomSheetState();
// }
//
// class _AddShortcutBottomSheetState extends State<AddShortcutBottomSheet> {
//   List<DashboardComponent> _allShortcuts = [];
//   List<String> _enabledKeys = [];
//   bool _loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadShortcuts();
//   }
//
//   Future<void> _loadShortcuts() async {
//     final allShortcuts = context.read<DashboardAnalyticsBloc>().allShortcuts;
//     final prefs = await SharedPreferences.getInstance();
//     final enabledKeys = prefs.getStringList('dashboard_shortcuts');
//     setState(() {
//       _allShortcuts = allShortcuts;
//       _enabledKeys = (enabledKeys ?? <String>[]);
//       _loading = false;
//     });
//   }
//
//   Future<void> _saveUpdate() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(
//       'dashboard_shortcuts',
//       _enabledKeys.isEmpty ? <String>[] : _enabledKeys,
//     );
//     final mainComponentOrder =
//         _enabledKeys
//             .map((k) => k.contains('|') ? k.split('|')[0] : k)
//             .toSet()
//             .toList();
//     await prefs.setStringList('dashboard_shortcut_order', mainComponentOrder);
//     if (mounted) {
//       context.read<DashboardAnalyticsBloc>().add(
//         RefreshDashboardShortcutsEvent(),
//       );
//     }
//   }
//
//   Future<void> _saveUpdateAndClose() async {
//     await _saveUpdate();
//     if (mounted) Navigator.pop(context);
//   }
//
//   void _toggleShortcut(String key) {
//     setState(() {
//       if (_enabledKeys.contains(key)) {
//         _enabledKeys.remove(key);
//       } else {
//         _enabledKeys.insert(0, key);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const Center(child: CircularProgressIndicator());
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       decoration: const BoxDecoration(
//         color: AppPalette.scaffoldBackgroundColor,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.close, color: AppPalette.darkGreyColor),
//                 onPressed: _saveUpdateAndClose,
//               ),
//
//               5.horizontalSpace,
//               CustomText(
//                 text: 'Add Shortcuts',
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _allShortcuts.length,
//               itemBuilder: (context, i) {
//                 final group = _allShortcuts[i];
//                 final hasSubItems = group.subItems.isNotEmpty;
//                 // For groups with subitems, collect all keys; for no subitems, use just the type name
//                 final groupKeys =
//                     hasSubItems
//                         ? group.subItems
//                             .map((sub) => '${group.type.name}|${sub.name}')
//                             .toList()
//                         : [group.type.name];
//                 // For groups with subitems: all checked? For no subitems: group key checked?
//                 final allChecked =
//                     hasSubItems
//                         ? groupKeys.every(_enabledKeys.contains)
//                         : _enabledKeys.contains(groupKeys.first);
//
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: CustomText(
//                               text: group.title,
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           SizedBox(
//                             height: 32,
//                             child: OutlinedButton(
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor:
//                                     allChecked
//                                         ? context.primaryColor
//                                         : Colors.white,
//                                 side: BorderSide(color: context.primaryColor),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   if (allChecked) {
//                                     // Uncheck all
//                                     for (final key in groupKeys) {
//                                       _enabledKeys.remove(key);
//                                     }
//                                   } else {
//                                     // Check all: insert each at the start, in reverse order
//                                     for (final key in groupKeys.reversed) {
//                                       _enabledKeys.remove(key);
//                                       _enabledKeys.insert(0, key);
//                                     }
//                                   }
//                                 });
//                                 _saveUpdateAndClose();
//                               },
//                               child: CustomText(
//                                 text: allChecked ? 'Added' : 'Add',
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color:
//                                     allChecked
//                                         ? Colors.white
//                                         : context.primaryColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (hasSubItems) ...[
//                         5.verticalSpace,
//                         ...group.subItems.map((sub) {
//                           final key = '${group.type.name}|${sub.name}';
//                           final checked = _enabledKeys.contains(key);
//                           return GestureDetector(
//                             onTap: () => _toggleShortcut(key),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.h),
//                               child: Row(
//                                 children: [
//                                   Transform.scale(
//                                     scale: 1.2,
//                                     child: Checkbox(
//                                       value: checked,
//                                       onChanged: (_) => _toggleShortcut(key),
//                                       shape: const CircleBorder(),
//                                       fillColor:
//                                           WidgetStateProperty.resolveWith<
//                                             Color
//                                           >((states) {
//                                             if (states.contains(
//                                               WidgetState.selected,
//                                             )) {
//                                               return context.primaryColor;
//                                             }
//                                             return Colors.transparent;
//                                           }),
//                                       visualDensity: const VisualDensity(
//                                         horizontal: -2,
//                                         vertical: -2,
//                                       ), // Make tick smaller
//                                       materialTapTargetSize:
//                                           MaterialTapTargetSize.shrinkWrap,
//                                       checkColor: Colors.white, // Tick color
//                                       side: BorderSide(
//                                         width: 2,
//                                         color: AppPalette.lightGreyColor,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 5),
//                                   Expanded(
//                                     child: CustomText(
//                                       text: sub.name,
//                                       fontSize: 14.sp,
//                                       color: AppPalette.hintColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                       ],
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 8),
//           CustomButton(onPressed: _saveUpdateAndClose, text: AppTexts.addAll),
//         ],
//       ),
//     );
//   }
// }
