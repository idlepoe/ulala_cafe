import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/models/youtube_track_model.dart';
import '../../../data/providers/chat_provider.dart';
import '../../../data/utils/snackbar_util.dart';
import '../../../data/utils/toss_loading_indicator.dart';
import '../../../data/utils/logger.dart';
import '../../main/controllers/main_controller.dart';

class MusicAttachModal extends StatefulWidget {
  final Function(YoutubeTrack) onTrackSelected;

  const MusicAttachModal({Key? key, required this.onTrackSelected})
    : super(key: key);

  @override
  _MusicAttachModalState createState() => _MusicAttachModalState();
}

class _MusicAttachModalState extends State<MusicAttachModal> {
  final TextEditingController _searchController = TextEditingController();
  final ChatProvider _chatProvider = Get.find<ChatProvider>();

  List<YoutubeTrack> _allTracks = [];
  List<YoutubeTrack> _filteredTracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    logger.d('MusicAttachModal: initState 호출');
    _loadTracks();
  }

  void _loadTracks() async {
    try {
      logger.d('MusicAttachModal: 트랙 로드 시작');
      setState(() {
        _isLoading = true;
      });

      final tracks = await _chatProvider.getAllUserTracks();
      logger.d('MusicAttachModal: 트랙 로드 완료 - ${tracks.length}개');

      for (var track in tracks) {
        logger.d('MusicAttachModal: 트랙 - ${track.title} (${track.videoId})');
      }

      setState(() {
        _allTracks = tracks;
        _filteredTracks = tracks;
        _isLoading = false;
      });

      logger.d('MusicAttachModal: UI 업데이트 완료');
    } catch (e) {
      logger.e('MusicAttachModal: 트랙 로드 실패 - $e');
      setState(() {
        _isLoading = false;
      });
      SnackbarUtil.showError('음악 목록을 불러오는데 실패했습니다');
    }
  }

  void _filterTracks(String query) {
    logger.d('MusicAttachModal: 필터링 시작 - 검색어: "$query"');
    logger.d('MusicAttachModal: 전체 트랙 수: ${_allTracks.length}');

    setState(() {
      if (query.isEmpty) {
        _filteredTracks = _allTracks;
        logger.d('MusicAttachModal: 필터링 해제 - 결과: ${_filteredTracks.length}개');
      } else {
        _filteredTracks = _allTracks
            .where(
              (track) =>
                  track.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        logger.d('MusicAttachModal: 필터링 완료 - 결과: ${_filteredTracks.length}개');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d(
      'MusicAttachModal: build 호출 - 로딩: $_isLoading, 전체 트랙: ${_allTracks.length}, 필터된 트랙: ${_filteredTracks.length}',
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 상단 핸들 바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 제목
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '음악 첨부',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filterTracks,
              decoration: InputDecoration(
                hintText: '곡 제목으로 검색',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 트랙 리스트
          Expanded(
            child: _isLoading
                ? const Center(
                    child: TossLoadingIndicator(size: 40, strokeWidth: 3.0),
                  )
                : _filteredTracks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '라이브러리에 음악이 없습니다',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            // 모달 닫기
                            Navigator.pop(context);
                            // 1번 탭(검색)으로 이동
                            final mainController = Get.find<MainController>();
                            mainController.changePage(1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.surface,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text(
                            '노래 추가',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredTracks.length,
                    itemBuilder: (context, index) {
                      final track = _filteredTracks[index];
                      logger.d(
                        'MusicAttachModal: ListView 아이템 빌드 - 인덱스: $index, 트랙: ${track.title}',
                      );
                      return _buildTrackItem(track);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackItem(YoutubeTrack track) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // 썸네일
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              track.thumbnail,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: AppColors.border,
                  child: const Icon(
                    Icons.music_note,
                    color: AppColors.textTertiary,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // 곡 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  track.channelTitle,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 첨부 버튼
          GestureDetector(
            onTap: () {
              widget.onTrackSelected(track);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.attach_file,
                color: AppColors.surface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
