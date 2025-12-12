import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/utils/app_static_data.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/pages/menu_page.dart';
import 'package:neuconnectz_dynea/src/shared/dashboard/widgets/custom_bottom_bar.dart';
import 'package:neuconnectz_dynea/src/shared/home/presentation/pages/home_page.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/presentation/blocs/plant_warehouse_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/selection/pages/document_selection_page.dart';
import 'package:neuconnectz_dynea/src/shared/selection/params/document_selection_params.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:terminate_restart/terminate_restart.dart';

import '../../../core/constants/app_palette.dart';
import '../../../core/constants/app_texts.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/status_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _shorebirdUpdater = ShorebirdUpdater();
  bool _isCheckingUpdate = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    if (!_shorebirdUpdater.isAvailable || _isCheckingUpdate) return;

    setState(() => _isCheckingUpdate = true);

    try {
      final status = await _shorebirdUpdater.checkForUpdate();

      switch (status) {
        case UpdateStatus.outdated:
          _showForceUpdateDialog();
          break;
        case UpdateStatus.restartRequired:
          await _handleConfirmationRestart();
          break;
        case UpdateStatus.upToDate:
        case UpdateStatus.unavailable:
          break;
      }
    } catch (e) {
      debugPrint('Shorebird update check failed: $e');
    } finally {
      setState(() => _isCheckingUpdate = false);
    }
  }

  void _showForceUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Update Available'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('An important update is being installed...'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
    );

    _shorebirdUpdater
        .update()
        .then((_) async {
          if (mounted) Navigator.of(context, rootNavigator: true).pop();
          await _handleTerminateRestart();
        })
        .catchError((error) {
          debugPrint('Failed to install update: $error');
          if (mounted) Navigator.of(context, rootNavigator: true).pop();
        });
  }

  Future<void> _handleTerminateRestart() async {
    await TerminateRestart.instance.restartApp(
      options: TerminateRestartOptions(
        terminate: true,
        clearData: false,
        preserveKeychain: true,
        preserveUserDefaults: true,
      ),
    );
  }

  Future<void> _handleConfirmationRestart() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            icon: const Icon(
              Icons.warning_rounded,
              size: 32,
              color: Colors.greenAccent,
            ),
            title: Text(AppTexts.restartRequired),
            content: Text(AppTexts.updateInstalledMessage),
            actions: [
              TextButton(
                onPressed: () async {
                  await _handleTerminateRestart();
                },
                child: Text(AppTexts.restartNow),
              ),
            ],
          ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return BlocProvider(
          create: (_) => sl<PlantWarehouseBloc>(),
          child: DocumentSelectionPage(
            params: DocumentSelectionConfigs.reservation(isScaffold: false),
          ),
        );
      case 2:
        return BlocProvider(
          create: (_) => sl<PlantWarehouseBloc>(),
          child: DocumentSelectionPage(
            params: DocumentSelectionConfigs.grn(isScaffold: false),
          ),
        );
      case 3:
        return const MenuPage();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
    // if (_selectedIndex == index) {
    //   if (index == 1) _refreshProductionOrders();
    //   if (index == 2) {
    //     _refreshInventoryTransferRequestListing();
    //   }
    // } else {
    //   if (index != 2) {
    //     _resetEvent();
    //   }
    //   setState(() => _selectedIndex = index);
    // }
  }

  // void _resetEvent() {
  //   context.read<InventoryTransferRequestBloc>().add(
  //     const ResetITRStateEvent(),
  //   );
  // }
  //
  // void _refreshProductionOrders() {
  //   context.read<ProductionOrderBloc>().add(
  //     FetchAllProductionOrdersEvent(ITRParams(), refresh: true),
  //   );
  // }
  //
  // void _refreshInventoryTransferRequestListing() {
  //   context.read<InventoryTransferRequestBloc>().add(
  //     FetchAllITREvent(ITRParams(type: ItrTypes.directITR.name), refresh: true),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_selectedIndex != 0) {
          setState(() => _selectedIndex = 0);
        } else {
          _showExitConfirmationDialog(context);
        }
      },
      child: Scaffold(
        extendBody: true,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: SafeArea(child: _getScreen(_selectedIndex)),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    AnimatedStatusDialog.show(
      context: context,
      isSuccess: false,
      title: AppTexts.areYouSure,
      message: AppTexts.doYouWantToExit,
      secondaryButtonText: AppTexts.yes,
      primaryButtonText: AppTexts.cancel,
      onSecondaryTap: () => exit(0),
    );
  }

  CustomAppBar _appBar() {
    return CustomAppBar(
      centerTitle: false,
      leadingWidth: 0,
      title: AppStaticData.dashboardTitles[_selectedIndex],
      leading: const SizedBox.shrink(),
      actions: [
        // if (_selectedIndex == 0)
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       // _openAddShortcutSheet();
        //     },
        //   ),
      ],
    );
  }

  // void _openAddShortcutSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     useSafeArea: true,
  //     builder: (BuildContext context) {
  //       return AddShortcutBottomSheet();
  //     },
  //   );
  // }

  Widget _bottomNavigationBar() {
    return Container(
      decoration: boxDecoration(),
      child: CustomLineIndicatorBottomNavbar(
        backgroundColor: Colors.white,
        splashColor: context.primaryColor.withAlpha(30),
        currentIndex: _selectedIndex,
        selectedItemColor: context.primaryColor,
        unselectedItemColor: AppPalette.greyColor,
        selectedFontSize: 14.sp,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: context.primaryColor,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: AppPalette.greyColor,
        ),
        unselectedFontSize: 14.sp,
        onTap: _onTabSelected,
        items: itemsList,
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(10),
          spreadRadius: 10,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  List<CustomBottomBarItem<dynamic>> get itemsList {
    return List.generate(
      4,
      (index) => CustomBottomBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: 5.h, bottom: 2.h),
          child: Transform.scale(
            scale: 1,
            child: Image.asset(
              AppStaticData.bottomBarIcons[index],
              width: 25.w,
              height: 25.w,
              color:
                  _selectedIndex == index
                      ? context.primaryColor
                      : AppPalette.greyColor,
            ),
          ),
        ),
        label: AppStaticData.bottomBarTitles[index],
      ),
    );
  }
}


