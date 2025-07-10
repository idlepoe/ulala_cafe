import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_pip_mode/actions/pip_action.dart';
import 'package:simple_pip_mode/actions/pip_actions_layout.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:ulala_cafe/app/modules/main/controllers/mini_player_controller.dart';
import 'package:ulala_cafe/app/modules/main/widgets/pip_child_widget.dart';
import 'package:ulala_cafe/app/modules/main/widgets/pip_widget.dart';
import '../controllers/main_controller.dart';
import '../widgets/mini_player_view.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../tab_home/views/tab_home_view.dart';
import '../../tab_search/views/tab_search_view.dart';
import '../../tab_library/views/tab_library_view.dart';
import '../../tab_cafe/views/tab_cafe_view.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pipWidget(
          child: Obx(() {
            switch (controller.currentIndex.value) {
              case 0:
                return const TabHomeView();
              case 1:
                return const TabSearchView();
              case 2:
                return const TabLibraryView();
              case 3:
                return const TabCafeView();
              default:
                return const TabHomeView();
            }
          }),
        ),
        bottomNavigationBar: Obx(() {
          var miniController = Get.find<MiniPlayerController>();
          var isPip = miniController.isPipModeActive.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 미니 플레이어
              const MiniPlayerView(),
              // 하단 네비게이션
              if (!isPip) ...[
                Container(
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
                      height: controller.isDenseNavigation.value
                          ? AppSizes.bottomNavHeight * 0.6
                          : AppSizes.bottomNavHeight,
                      child: Row(
                        children: [
                          _buildNavItem(0, Icons.home, '홈'),
                          _buildNavItem(1, Icons.search, '검색'),
                          _buildNavItem(2, Icons.library_music, '라이브러리'),
                          _buildNavItem(3, Icons.coffee, 'CAFE'),
                          // Dense 모드 toggle 버튼
                          _buildDenseToggleButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.currentIndex.value == index;
        return GestureDetector(
          onTap: () => controller.changePage(index),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: controller.isDenseNavigation.value
                ? AppSizes.bottomNavHeight * 0.6
                : AppSizes.bottomNavHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.inactive,
                  size: controller.isDenseNavigation.value
                      ? AppSizes.iconS
                      : AppSizes.iconM,
                ),
                if (!controller.isDenseNavigation.value) ...[
                  SizedBox(height: AppSizes.spacingXS),
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.inactive,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDenseToggleButton() {
    return Container(
      width: 50,
      child: Obx(() {
        return GestureDetector(
          onTap: () => controller.toggleDenseNavigation(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: controller.isDenseNavigation.value
                ? AppSizes.bottomNavHeight * 0.6
                : AppSizes.bottomNavHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isDenseNavigation.value
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: AppColors.primary,
                  size: controller.isDenseNavigation.value
                      ? AppSizes.iconS
                      : AppSizes.iconM,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
