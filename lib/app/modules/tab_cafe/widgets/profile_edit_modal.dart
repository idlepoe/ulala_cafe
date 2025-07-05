import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/utils/toss_loading_indicator.dart';

class ProfileEditModal extends StatefulWidget {
  const ProfileEditModal({Key? key}) : super(key: key);

  @override
  State<ProfileEditModal> createState() => _ProfileEditModalState();
}

class _ProfileEditModalState extends State<ProfileEditModal> {
  late final TextEditingController _displayNameController;
  late final FocusNode _focusNode;
  final ImagePicker _imagePicker = ImagePicker();

  String? _currentPhotoUrl;
  String? _selectedImagePath;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _displayNameController = TextEditingController(
      text: user?.displayName ?? '',
    );
    _focusNode = FocusNode();
    _currentPhotoUrl = user?.photoURL;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      SnackbarUtil.showError('이미지 선택 중 오류가 발생했습니다.');
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImagePath == null) return null;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final file = File(_selectedImagePath!);
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('이미지 업로드 실패: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        SnackbarUtil.showError('로그인이 필요합니다.');
        return;
      }

      String? newPhotoUrl = _currentPhotoUrl;

      // 이미지가 선택되었다면 업로드
      if (_selectedImagePath != null) {
        newPhotoUrl = await _uploadImage();
      }

      // Firebase Auth 프로필 업데이트
      await user.updateDisplayName(_displayNameController.text.trim());
      if (newPhotoUrl != null) {
        await user.updatePhotoURL(newPhotoUrl);
      }

      // 프로필 새로고침
      await user.reload();

      Get.back(result: true);
      SnackbarUtil.showSuccess('프로필이 업데이트되었습니다.');
    } catch (e) {
      SnackbarUtil.showError('프로필 업데이트 중 오류가 발생했습니다.');
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 핸들
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: AppSizes.marginL),

              // 제목
              Text(
                '프로필 수정',
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSizes.marginL),

              // 프로필 이미지
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.border,
                    backgroundImage: _selectedImagePath != null
                        ? FileImage(File(_selectedImagePath!))
                        : (_currentPhotoUrl != null
                                  ? NetworkImage(_currentPhotoUrl!)
                                  : null)
                              as ImageProvider?,
                    child:
                        _selectedImagePath == null && _currentPhotoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.textSecondary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.marginL),

              // 닉네임 레이블
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '닉네임',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.marginS),

              // 닉네임 입력창
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: TextField(
                  controller: _displayNameController,
                  focusNode: _focusNode,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '닉네임을 입력하세요',
                    hintStyle: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(AppSizes.paddingM),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onSubmitted: (_) => _updateProfile(),
                ),
              ),
              SizedBox(height: AppSizes.marginL),

              // 버튼들
              Row(
                children: [
                  // 닫기 버튼
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
                        '닫기',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.marginM),

                  // 저장 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUpdating ? null : _updateProfile,
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
                              '저장',
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
