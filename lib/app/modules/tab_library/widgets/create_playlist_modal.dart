import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/providers/playlist_provider.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/utils/toss_loading_indicator.dart';

class CreatePlaylistModal extends StatefulWidget {
  final String initialName;

  const CreatePlaylistModal({Key? key, required this.initialName})
    : super(key: key);

  @override
  State<CreatePlaylistModal> createState() => _CreatePlaylistModalState();
}

class _CreatePlaylistModalState extends State<CreatePlaylistModal> {
  late final TextEditingController _nameController;
  late final FocusNode _focusNode;
  final PlaylistProvider _playlistProvider = Get.find<PlaylistProvider>();
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
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

  Future<void> _createPlaylist() async {
    if (_nameController.text.trim().isEmpty) {
      SnackbarUtil.showError('플레이리스트 이름을 입력해주세요.');
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final playlistId = await _playlistProvider.createPlaylist(
        _nameController.text.trim(),
      );

      if (playlistId != null) {
        Get.back();
        SnackbarUtil.showSuccess('플레이리스트가 생성되었습니다.');
      } else {
        SnackbarUtil.showError('플레이리스트 생성에 실패했습니다.');
      }
    } catch (e) {
      SnackbarUtil.showError('플레이리스트 생성 중 오류가 발생했습니다.');
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
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
                '새 플레이리스트',
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
                  onSubmitted: (_) => _createPlaylist(),
                ),
              ),
              SizedBox(height: AppSizes.marginL),

              // 버튼들
              Row(
                children: [
                  // 취소 버튼
                  Expanded(
                    child: TextButton(
                      onPressed: _isCreating ? null : () => Get.back(),
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

                  // 생성 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isCreating ? null : _createPlaylist,
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
                      child: _isCreating
                          ? const TossLoadingIndicator(
                              size: 20,
                              strokeWidth: 2.0,
                            )
                          : Text(
                              '생성',
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
