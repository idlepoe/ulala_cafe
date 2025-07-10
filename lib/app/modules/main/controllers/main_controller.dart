import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../tab_home/views/tab_home_view.dart';
import '../../tab_search/views/tab_search_view.dart';
import '../../tab_library/views/tab_library_view.dart';
import '../../tab_cafe/views/tab_cafe_view.dart';
import '../../tab_library/controllers/tab_library_controller.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;
  final isDenseNavigation = false.obs; // dense 네비게이션 모드 상태

  static const String _denseNavigationKey = 'is_dense_navigation';

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

    // 라이브러리 탭이 선택되었을 때 플레이리스트 목록 새로 로드
    if (index == 2 && Get.isRegistered<TabLibraryController>()) {
      final libraryController = Get.find<TabLibraryController>();
      libraryController.loadPlaylists();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadDenseNavigationState();
  }

  void toggleDenseNavigation() async {
    isDenseNavigation.value = !isDenseNavigation.value;
    await _saveDenseNavigationState();
  }

  Future<void> _loadDenseNavigationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDenseNavigation.value = prefs.getBool(_denseNavigationKey) ?? false;
    } catch (e) {
      // 에러 발생 시 기본값 사용
      isDenseNavigation.value = false;
    }
  }

  Future<void> _saveDenseNavigationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_denseNavigationKey, isDenseNavigation.value);
    } catch (e) {
      // 에러 발생 시 무시
    }
  }
}
