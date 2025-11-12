// import 'package:flutter/material.dart';
// import 'package:shorebird_code_push/shorebird_code_push.dart';
//
// import '../../../../core/barrels/itr_barrel.dart';
//
// class CurrentPatchVersion extends StatelessWidget {
//   final String? number;
//   final Patch? patch;
//   const CurrentPatchVersion({super.key, required this.patch, this.number});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Visibility(
//       visible: true,
//       // visible: patch != null,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             CustomText(text: 'Current patch version:'),
//             CustomText(
//               text: patch != null ? '${patch!.number}' : 'No patch installed',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
