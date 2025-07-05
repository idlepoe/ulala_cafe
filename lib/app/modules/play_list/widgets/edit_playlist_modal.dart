import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/providers/playlist_provider.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/utils/toss_loading_indicator.dart';

class EditPlaylistModal extends StatefulWidget {
  final String playlistId;
  final String currentName;

  const EditPlaylistModal({
    Key? key,
    required this.playlistId,
    required this.currentName,
  }) : super(key: key);

  @override
  State<EditPlaylistModal> createState() => _EditPlaylistModalState();
}

class _EditPlaylistModalState extends State<EditPlaylistModal> {
  late final TextEditingController _nameController;
  late final FocusNode _focusNode;
  final PlaylistProvider _playlistProvider = Get.find<PlaylistProvider>();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _focusNode = FocusNode();

    // 모달이 열릴 때 입력창에 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _nameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _nameController.text.length,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _updatePlaylist() async {
    if (_nameController.text.trim().isEmpty) {
      SnackbarUtil.showError('플레이리스트 이름을 입력해주세요.');
      return;
    }

    // 기존 이름과 같으면 업데이트하지 않음
    if (_nameController.text.trim() == widget.currentName) {
      Get.back();
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final success = await _playlistProvider.updatePlaylistName(
        widget.playlistId,
        _nameController.text.trim(),
      );

      if (success) {
        Get.back(result: _nameController.text.trim());
        SnackbarUtil.showSuccess('플레이리스트 이름이 변경되었습니다.');
      } else {
        SnackbarUtil.showError('플레이리스트 이름 변경에 실패했습니다.');
      }
    } catch (e) {
      SnackbarUtil.showError('플레이리스트 이름 변경 중 오류가 발생했습니다.');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusL),
        ),
      ),
      child: SingleChildScrollView(
        child: AnimatedPadding(
          padding: EdgeInsets.only(
            left: AppSizes.paddingL,
            right: AppSizes.paddingL,
            top: AppSizes.paddingL,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? AppSizes.paddingL
                : AppSizes.paddingL,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 핸들
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.marginL),

              // 제목
              Text(
                '플레이리스트 수정',
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSizes.marginM),

              // 레이블
              Text(
                '플레이리스트 이름',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.marginS),

              // 입력창
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: TextField(
                  controller: _nameController,
                  focusNode: _focusNode,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '플레이리스트 이름을 입력하세요',
                    hintStyle: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(AppSizes.paddingM),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onSubmitted: (_) => _updatePlaylist(),
                ),
              ),
              SizedBox(height: AppSizes.marginL),

              // 버튼들
              Row(
                children: [
                  // 취소 버튼
                  Expanded(
                    child: TextButton(
                      onPressed: _isUpdating ? null : () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingM,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                      ),
                      child: Text(
                        '취소',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.marginM),

                  // 수정 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUpdating ? null : _updatePlaylist,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingM,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                      ),
                      child: _isUpdating
                          ? const TossLoadingIndicator(
                              size: 20,
                              strokeWidth: 2.0,
                            )
                          : Text(
                              '수정',
                              style: AppTextStyles.body1.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
