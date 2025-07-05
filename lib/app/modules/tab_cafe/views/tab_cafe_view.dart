import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/tab_cafe_controller.dart';
import '../../../data/constants/app_colors.dart';
import '../../../data/constants/app_sizes.dart';
import '../../../data/constants/app_text_styles.dart';
import '../../../data/models/chat_message_model.dart';
import '../widgets/music_message_widget.dart';

class TabCafeView extends GetView<TabCafeController> {
  const TabCafeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더 + 카드
            _buildHeader(),

            // 채팅 메시지 리스트
            Expanded(child: _buildMessageList()),

            // 하단 메시지 입력창
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        children: [
          // 제목과 프로필
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CAFE', style: AppTextStyles.h1),
              // 프로필 영역
              Obx(
                () => GestureDetector(
                  onTap: () => controller.showProfileEditModal(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 프로필 아바타
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.border,
                        backgroundImage:
                            (controller.photoUrl?.isNotEmpty == true)
                            ? NetworkImage(controller.photoUrl!)
                            : null,
                        child: (controller.photoUrl?.isEmpty != false)
                            ? Icon(
                                Icons.person,
                                size: 24,
                                color: AppColors.textSecondary,
                              )
                            : null,
                      ),
                      SizedBox(width: AppSizes.marginS),
                      // 사용자 이름
                      Text(
                        controller.displayName,
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.marginL),

          // 카페 설명 카드 (얇게 표시)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingM, // 세로 패딩 줄임
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: AppSizes.shadowBlurRadius,
                  offset: Offset(0, AppSizes.shadowOffsetY),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.coffee,
                  color: AppColors.primary,
                  size: AppSizes.iconM, // 아이콘 크기 줄임
                ),
                SizedBox(width: AppSizes.marginM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('음악 카페', style: AppTextStyles.h4), // 제목 크기 줄임
                      SizedBox(height: 2),
                      Text(
                        '다른 사람과 음악과 이야기를 나누는 공간입니다.',
                        style: AppTextStyles.body2.copyWith(
                          // 설명 크기 줄임
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // 활성 사용자 수
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingS,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person,
                          size: 14, // 아이콘 크기 줄임
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${controller.activeUsers}',
                          style: AppTextStyles.caption.copyWith(
                            // 텍스트 크기 줄임
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: Obx(() {
        if (controller.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                SizedBox(height: AppSizes.marginM),
                Text(
                  '아직 메시지가 없습니다.\n첫 번째 메시지를 보내보세요!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: controller.scrollController,
          reverse: true, // 리스트를 역순으로 표시하여 하단부터 시작
          itemCount:
              controller.messages.length + (controller.hasMoreMessages ? 1 : 0),
          itemBuilder: (context, index) {
            // 더 보기 버튼 (역순이므로 맨 마지막에 표시)
            if (index == controller.messages.length &&
                controller.hasMoreMessages) {
              return _buildLoadMoreButton();
            }

            // 메시지 인덱스 조정 (역순이므로 뒤에서부터)
            final messageIndex = controller.messages.length - 1 - index;
            final message = controller.messages[messageIndex];
            final isMyMessage = controller.isMyMessage(message);

            return _buildMessageBubble(message, isMyMessage);
          },
        );
      }),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMyMessage) {
    return Container(
      margin: EdgeInsets.only(
        top: AppSizes.marginS,
        left: isMyMessage ? 60 : 0,
        right: isMyMessage ? 0 : 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMyMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // 상대방 메시지일 때 프로필 이미지
          if (!isMyMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.border,
              backgroundImage: (message.photoUrl?.isNotEmpty == true)
                  ? NetworkImage(message.photoUrl!)
                  : null,
              child: (message.photoUrl?.isEmpty != false)
                  ? Icon(Icons.person, size: 16, color: AppColors.textSecondary)
                  : null,
            ),
            SizedBox(width: AppSizes.marginS),
          ],

          // 메시지 내용
          Flexible(
            child: Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // 사용자 이름 (상대방 메시지일 때만)
                if (!isMyMessage) ...[
                  Text(
                    message.displayName,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                ],

                // 메시지 버블
                GestureDetector(
                  onLongPress: isMyMessage
                      ? () => _showDeleteDialog(message)
                      : null,
                  child: _buildMessageContent(message, isMyMessage),
                ),

                // 시간
                SizedBox(height: 2),
                Text(
                  _formatTime(message.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // 본인 메시지일 때 프로필 이미지
          if (isMyMessage) ...[
            SizedBox(width: AppSizes.marginS),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.border,
              backgroundImage: (message.photoUrl?.isNotEmpty == true)
                  ? NetworkImage(message.photoUrl!)
                  : null,
              child: (message.photoUrl?.isEmpty != false)
                  ? Icon(Icons.person, size: 16, color: AppColors.textSecondary)
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message, bool isMyMessage) {
    // 음악 메시지인 경우
    if (message.type == 'music' && message.youtubeTrack != null) {
      return MusicMessageWidget(
        track: message.youtubeTrack!,
        isMyMessage: isMyMessage,
      );
    }

    // 일반 텍스트 메시지인 경우
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color: isMyMessage ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusM),
          topRight: Radius.circular(AppSizes.radiusM),
          bottomLeft: Radius.circular(
            isMyMessage ? AppSizes.radiusM : AppSizes.radiusS,
          ),
          bottomRight: Radius.circular(
            isMyMessage ? AppSizes.radiusS : AppSizes.radiusM,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.message,
        style: AppTextStyles.body1.copyWith(
          color: isMyMessage ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      margin: EdgeInsets.only(bottom: AppSizes.marginM),
      child: Obx(() {
        if (controller.isLoadingMore) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return Center(
          child: ElevatedButton.icon(
            onPressed: () => controller.loadMoreMessages(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              elevation: 2,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingS,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                side: const BorderSide(color: AppColors.primary),
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_up, size: 20),
            label: const Text('이전 메시지 더 보기', style: TextStyle(fontSize: 14)),
          ),
        );
      }),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM, // 세로 패딩 줄임
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 음악 첨부 버튼
            GestureDetector(
              onTap: () => controller.showMusicAttachModal(),
              child: Container(
                padding: const EdgeInsets.all(6), // 패딩 줄임
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18), // 크기 약간 줄임
                ),
                child: const Icon(
                  Icons.music_note,
                  color: AppColors.surface,
                  size: 18, // 아이콘 크기 줄임
                ),
              ),
            ),
            const SizedBox(width: 10), // 간격 줄임
            // 텍스트 입력 필드
            Expanded(
              child: TextField(
                controller: controller.messageController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ), // 라운드 줄임
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14, // 좌우 패딩 줄임
                    vertical: 10, // 상하 패딩 줄임
                  ),
                ),
                onSubmitted: (_) => controller.sendTextMessage(),
              ),
            ),
            const SizedBox(width: 6), // 간격 줄임
            // 전송 버튼
            GestureDetector(
              onTap: () => controller.sendTextMessage(),
              child: Container(
                padding: const EdgeInsets.all(8), // 패딩 줄임
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18), // 크기 약간 줄임
                ),
                child: const Icon(
                  Icons.send,
                  color: AppColors.surface,
                  size: 18, // 아이콘 크기 줄임
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(ChatMessage message) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          '메시지 삭제',
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          '이 메시지를 삭제하시겠습니까?',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              '취소',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteMessage(message);
            },
            child: Text(
              '삭제',
              style: AppTextStyles.body1.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('MM/dd HH:mm').format(timestamp);
    } else if (difference.inHours > 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else {
      return DateFormat('HH:mm').format(timestamp);
    }
  }
}
