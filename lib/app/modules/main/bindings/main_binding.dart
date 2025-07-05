import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import '../controllers/mini_player_controller.dart';
import '../../tab_home/controllers/tab_home_controller.dart';
import '../../tab_search/controllers/tab_search_controller.dart';
import '../../tab_library/controllers/tab_library_controller.dart';
import '../../tab_cafe/controllers/tab_cafe_controller.dart';
import '../../../data/providers/search_provider.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Main Controller
    Get.lazyPut<MainController>(() => MainController());

    // Providers
    Get.lazyPut<SearchProvider>(() => SearchProvider());

    // Tab Controllers
    Get.put<TabHomeController>(TabHomeController());
    Get.put<TabSearchController>(TabSearchController());
    Get.put<TabLibraryController>(TabLibraryController());
    Get.put<TabCafeController>(TabCafeController());

    // Mini Player Controller
    Get.put<MiniPlayerController>(MiniPlayerController(), permanent: true);
  }
}
