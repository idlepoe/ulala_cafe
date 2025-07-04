import 'package:get/get.dart';

import '../controllers/tab_search_controller.dart';
import '../../../data/providers/search_provider.dart';

class TabSearchBinding extends Bindings {
  @override
  void dependencies() {
    // 이미 MainBinding에서 등록되므로 여기서는 제거
    // Get.lazyPut<SearchProvider>(() => SearchProvider());
    // Get.lazyPut<TabSearchController>(() => TabSearchController());
  }
}
