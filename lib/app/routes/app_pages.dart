import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/play_list/bindings/play_list_binding.dart';
import '../modules/play_list/views/play_list_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tab_cafe/bindings/tab_cafe_binding.dart';
import '../modules/tab_cafe/views/tab_cafe_view.dart';
import '../modules/tab_home/bindings/tab_home_binding.dart';
import '../modules/tab_home/views/tab_home_view.dart';
import '../modules/tab_library/bindings/tab_library_binding.dart';
import '../modules/tab_library/views/tab_library_view.dart';
import '../modules/tab_search/bindings/tab_search_binding.dart';
import '../modules/tab_search/views/tab_search_view.dart';
import '../modules/webview/bindings/webview_binding.dart';
import '../modules/webview/views/webview_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.TAB_HOME,
      page: () => const TabHomeView(),
      binding: TabHomeBinding(),
    ),
    GetPage(
      name: Routes.TAB_SEARCH,
      page: () => const TabSearchView(),
      binding: TabSearchBinding(),
    ),
    GetPage(
      name: Routes.TAB_LIBRARY,
      page: () => const TabLibraryView(),
      binding: TabLibraryBinding(),
    ),
    GetPage(
      name: Routes.TAB_CAFE,
      page: () => const TabCafeView(),
      binding: TabCafeBinding(),
    ),
    GetPage(
      name: Routes.PLAY_LIST,
      page: () => const PlayListView(),
      binding: PlayListBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.WEBVIEW,
      page: () => const WebViewView(),
      binding: WebViewBinding(),
    ),
  ];
}
