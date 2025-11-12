// import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_texts.dart';
import 'package:neuconnectz_dynea/src/core/dependency_injection/di_barrel.dart';
import 'package:neuconnectz_dynea/src/core/extensions/context_extensions.dart';
import 'package:neuconnectz_dynea/src/core/observers/app_bloc_observer.dart';
import 'package:neuconnectz_dynea/src/core/router/app_router.dart';
import 'package:neuconnectz_dynea/src/core/theme/cubits/theme_cubit.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/cubits/user_cubit.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/presentation/blocs/plant_warehouse_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  //ChuckerFlutter.showOnRelease = true;
  //ChuckerFlutter.showNotification = false;
  await initializeDI();

  _runApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      //statusBarColor: Colors.white,
    ),
  );
}

void _runApp() {
  return runApp(
    MultiBlocProvider(
      providers: [
        /// ================ Core ===================
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<AuthenticationBloc>()),
        BlocProvider(create: (_) => sl<UserCubit>()),

        /// =========== Features ====================
        BlocProvider(create: (_) => sl<PlantWarehouseBloc>()),
        //  BlocProvider(create: (_) => sl<DashboardAnalyticsBloc>()),
      ],
      child: DevicePreview(enabled: false, builder: (context) => MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, themeState) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppTexts.appTitle,
          theme: themeState,
          routerConfig: appRouter,
          builder: (context, child) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.unfocusFocusScope(),
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
                child: ScreenUtilInit(
                  designSize: const Size(428, 926),
                  splitScreenMode: true,
                  useInheritedMediaQuery: true,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
