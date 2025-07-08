import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:simple_pip_mode/actions/pip_action.dart';
import 'package:simple_pip_mode/actions/pip_actions_layout.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:ulala_cafe/app/modules/main/controllers/mini_player_controller.dart';
import 'package:ulala_cafe/app/modules/main/widgets/pip_child_widget.dart';

Widget pipWidget({required Widget child}) {
  var controller = Get.find<MiniPlayerController>();
  return PipWidget(
    pipChild: const PipChildWidget(),
    pipLayout: PipActionsLayout.media,
    onPipEntered: () {
      // PiP 모드 진입 - 재생 중이고 플레이어가 보일 때만
      if (controller.isPlaying.value && controller.isPlayerVisible.value) {
        controller.isPipModeActive.value = true;
      }
    },
    onPipExited: () {
      // PiP 모드 종료
      controller.isPipModeActive.value = false;
    },
    onPipAction: (action) {
      // PiP 모드에서의 미디어 컨트롤
      switch (action) {
        case PipAction.play:
          controller.playPlayer();
          break;
        case PipAction.pause:
          controller.pausePlayer();
          break;
        case PipAction.next:
          controller.playNext();
          break;
        case PipAction.previous:
          controller.playPrevious();
          break;
        default:
          break;
      }
    },
    child: child,
  );
}
