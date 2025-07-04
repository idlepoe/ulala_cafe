import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_cafe/app/data/constants/app_colors.dart';
import 'package:ulala_cafe/app/data/constants/app_sizes.dart';
import 'package:ulala_cafe/app/data/constants/app_text_styles.dart';

import '../controllers/main_controller.dart';
import '../../tab_home/views/tab_home_view.dart';
import '../../tab_search/views/tab_search_view.dart';
import '../../tab_library/views/tab_library_view.dart';
import '../../tab_cafe/views/tab_cafe_view.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return const Scaffold(body: TabHomeView());
          case 1:
            return const Scaffold(body: TabSearchView());
          case 2:
            return const Scaffold(body: TabLibraryView());
          case 3:
            return const Scaffold(body: TabCafeView());
          default:
            return const Scaffold(body: TabHomeView());
        }
      }),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: AppColors.bottomNavBackground,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: AppSizes.shadowBlurRadius,
                offset: Offset(0, -AppSizes.shadowOffsetY),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: AppSizes.bottomNavHeight,
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home, '홈'),
                  _buildNavItem(1, Icons.search, '검색'),
                  _buildNavItem(2, Icons.library_music, '라이브러리'),
                  _buildNavItem(3, Icons.coffee, 'CAFE'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingS,
          horizontal: AppSizes.paddingM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.bottomNavIconSize,
              color: isSelected
                  ? AppColors.bottomNavSelected
                  : AppColors.bottomNavUnselected,
            ),
            SizedBox(height: AppSizes.marginXS),
            Text(
              label,
              style: AppTextStyles.bottomNav.copyWith(
                color: isSelected
                    ? AppColors.bottomNavSelected
                    : AppColors.bottomNavUnselected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
