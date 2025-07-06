import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_cafe/app/data/utils/logger.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/providers/playlist_provider.dart';
import '../../../data/models/playlist_model.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/utils/toss_loading_indicator.dart';
import '../../../data/utils/snackbar_util.dart';

class PlaylistSelectorDialog extends StatefulWidget {
  final YoutubeTrack track;

  const PlaylistSelectorDialog({Key? key, required this.track})
    : super(key: key);

  @override
  State<PlaylistSelectorDialog> createState() => _PlaylistSelectorDialogState();
}

class _PlaylistSelectorDialogState extends State<PlaylistSelectorDialog> {
  final PlaylistProvider _playlistProvider = Get.find<PlaylistProvider>();
  final Set<String> _selectedPlaylistIds = <String>{};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '동영상 저장',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.marginXS),
                        Text(
                          widget.track.title,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            // 플레이리스트 목록
            Flexible(
              child: Obx(() {
                if (_playlistProvider.playlists.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(AppSizes.paddingL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_add,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: AppSizes.marginM),
                        Text(
                          '플레이리스트가 없습니다.',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.paddingS),
                  itemCount: _playlistProvider.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = _playlistProvider.playlists[index];
                    final isSelected = _selectedPlaylistIds.contains(
                      playlist.id,
                    );
                    final thumbnailUrl = playlist.tracks.isNotEmpty
                        ? playlist.tracks.first.thumbnail
                        : '';

                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedPlaylistIds.add(playlist.id);
                          } else {
                            _selectedPlaylistIds.remove(playlist.id);
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingL,
                        vertical: AppSizes.paddingS,
                      ),
                      secondary: SizedBox(
                        width: 48,
                        height: 48,
                        child: thumbnailUrl.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusS,
                                  ),
                                ),
                                child: Icon(
                                  Icons.music_note,
                                  size: AppSizes.iconM,
                                  color: AppColors.textSecondary,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusS,
                                ),
                                child: Image.network(
                                  thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusS,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.music_note,
                                        size: AppSizes.iconM,
                                        color: AppColors.textSecondary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                      title: Text(
                        playlist.name,
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${playlist.tracks.length}곡',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // 새 재생목록 버튼
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
              child: TextButton.icon(
                onPressed: _showCreatePlaylistDialog,
                icon: Icon(Icons.add, color: AppColors.primary),
                label: Text(
                  '새 재생목록',
                  style: AppTextStyles.body1.copyWith(color: AppColors.primary),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.paddingM),
                ),
              ),
            ),

            // 하단 버튼들
            Container(
              padding: EdgeInsets.all(AppSizes.paddingL),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingM,
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
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedPlaylistIds.isEmpty || _isLoading
                          ? null
                          : _saveToSelectedPlaylists,
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
                      child: _isLoading
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
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    final playlistName = _playlistProvider.generatePlaylistName();
    final playlistNameController = TextEditingController(text: playlistName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        title: Text(
          '새 플레이리스트',
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        content: TextField(
          autofocus: true,
          controller: playlistNameController,
          style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            labelText: '플레이리스트 이름',
            labelStyle: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          onSubmitted: (value) => _createPlaylist(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _createPlaylist(playlistNameController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('생성'),
          ),
        ],
      ),
    );
  }

  Future<void> _createPlaylist(String name) async {
    logger.d('createPlaylist: $name');
    if (name.trim().isEmpty) {
      SnackbarUtil.showError('플레이리스트 이름을 입력해주세요.');
      return;
    }

    Navigator.of(context).pop(); // 다이얼로그 닫기

    try {
      final playlistId = await _playlistProvider.createPlaylist(name.trim());
      if (playlistId != null) {
        setState(() {
          _selectedPlaylistIds.add(playlistId);
        });
        SnackbarUtil.showSuccess('플레이리스트가 생성되었습니다.');
      } else {
        SnackbarUtil.showError('플레이리스트 생성에 실패했습니다.');
      }
    } catch (e) {
      SnackbarUtil.showError('플레이리스트 생성 중 오류가 발생했습니다.');
    }
  }

  Future<void> _saveToSelectedPlaylists() async {
    if (_selectedPlaylistIds.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      int successCount = 0;
      int duplicateCount = 0;

      for (final playlistId in _selectedPlaylistIds) {
        final success = await _playlistProvider.addTrackToPlaylist(
          playlistId,
          widget.track,
        );
        if (success) {
          successCount++;
        } else {
          duplicateCount++;
        }
      }

      Get.back(); // 다이얼로그 닫기

      if (successCount > 0) {
        if (duplicateCount > 0) {
          SnackbarUtil.showInfo(
            '${successCount}개 플레이리스트에 추가되었습니다. (중복 ${duplicateCount}개 제외)',
          );
        } else {
          SnackbarUtil.showSuccess('${successCount}개 플레이리스트에 추가되었습니다.');
        }
      } else {
        SnackbarUtil.showWarning('모든 플레이리스트에 이미 존재하는 곡입니다.');
      }
    } catch (e) {
      SnackbarUtil.showError('저장 중 오류가 발생했습니다.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
