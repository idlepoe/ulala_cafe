import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../tab_home/views/tab_home_view.dart';
import '../../tab_search/views/tab_search_view.dart';
import '../../tab_library/views/tab_library_view.dart';
import '../../tab_cafe/views/tab_cafe_view.dart';
import '../../tab_library/controllers/tab_library_controller.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  final List<Widget> pages = [
    const TabHomeView(),
    const TabSearchView(),
    const TabLibraryView(),
    const TabCafeView(),
  ];

  final List<BottomNavigationBarItem> navigationItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
    const BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
    const BottomNavigationBarItem(
      icon: Icon(Icons.library_music),
      label: '라이브러리',
    ),
    const BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'CAFE'),
  ];

  void changePage(int index) {
    // 라이브러리 탭을 눌렀을 때 플레이리스트가 열려있으면 닫기
    if (index == 2 && Get.isRegistered<TabLibraryController>()) {
      final libraryController = Get.find<TabLibraryController>();
      if (libraryController.showPlaylistView.value) {
        libraryController.closePlaylist();
        return; // 플레이리스트만 닫고 탭 변경은 하지 않음
      }
    }

    currentIndex.value = index;
  }
}
