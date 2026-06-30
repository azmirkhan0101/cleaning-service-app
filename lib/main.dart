import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/dependency/dependency_injection.dart';
import 'package:cleaning_service_app/core/service/app_storage_service.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';

import 'core/service/subscription_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize storage services
  await AppStorageService.init();
  await GetStorage.init();
  Get.putAsync(() => SubscriptionService().init());


  DependencyInjection di = DependencyInjection();
  di.dependencies();

  runApp(
    DevicePreview(
      // enabled: !kReleaseMode,
      enabled: false,
      builder: (context) {
        return const MyApp();
      },
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /*     runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) =>
    ///====================
    MyApp(), // Wrap your app
  ));*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return OKToast(
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: const Size(411, 797),
        child: GetMaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            appBarTheme: const AppBarTheme(
              //surfaceTintColor: AppColors.brinkPink,
              toolbarHeight: 65,
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.white,
              iconTheme: IconThemeData(color: AppColors.black),
              // iconTheme: IconThemeData(color: AppColors.white),
            ),
            inputDecorationTheme: _buildInputDecorationTheme(),
          ),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
          initialRoute: AppRoutes.splashScreen,
          navigatorKey: Get.key,
          getPages: AppRoutes.routes
        ),
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorMaxLines: 2,
      hintStyle: TextStyle(
        color: const Color(0xFF4899D1),
        fontSize: 14,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
      suffixIconColor: Color(0xFF4899D1),
      filled: true,
      fillColor: Color(0xFFE9EBF3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
