import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- [ลบ] Import นี้ ---
// import 'data/services/dependency_injection.dart'; 
import 'data/services/theme_service.dart';
import 'data/services/translations_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'ui/layouts/main/main_layout.dart';
import 'ui/pages/unknown_route_page/unknown_route_page.dart';
import 'ui/theme/themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food near me app',
      debugShowCheckedModeBanner: false,
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeService().getThemeMode(),
      translations: Translation(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      initialRoute: AppRoutes.SPLASH,
      unknownRoute: AppPages.unknownRoutePage,
      getPages: AppPages.pages,
      builder: (_, child) {
        if (child == null) {
          return UnknownRoutePage();
        }

        return MainLayout(child: child);
      },
    );
  }
}