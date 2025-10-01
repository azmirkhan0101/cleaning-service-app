import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/features/dependency/dependency_injection.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:device_preview/device_preview.dart';

void main() async{

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark
  ));

  DependencyInjection di = DependencyInjection();
  di.dependencies();

  await GetStorage.init();

  runApp(const MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


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
    debugPrint("${MediaQuery.sizeOf(context).height}");
    debugPrint("${MediaQuery.sizeOf(context).width}");

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
                  iconTheme: IconThemeData(color: AppColors.white))),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
          initialRoute: AppRoutes.splashScreen,
          navigatorKey: Get.key,
          getPages: AppRoutes.routes,

        ),
      ),
    );
  }
}
