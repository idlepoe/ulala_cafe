import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/youtube_track_model.dart';
import 'dio.dart';
import 'logger.dart';

class ApiService {
  /// YouTube 검색 (Firebase Functions 활용)
  static Future<Map<String, dynamic>> youtubeSearch({
    required String search,
    String? pageToken,
  }) async {
    try {
      if (search.trim().isEmpty) {
        throw Exception('검색어를 입력해주세요.');
      }

      final response = await dio.post(
        '/youtubeSearch',
        data: {'search': search, if (pageToken != null) 'pageToken': pageToken},
      );

      final data = response.data;
      if (data['success'] == true) {
        final List<dynamic> results = data['data'];
        final tracks = results
            .map((json) => YoutubeTrack.fromJson(json))
            .toList();

        return {
          'tracks': tracks,
          'nextPageToken': data['nextPageToken'],
          'totalResults': data['totalResults'] ?? 0,
          'fromCache': data['fromCache'] ?? false,
        };
      } else {
        throw Exception(data['message'] ?? '검색 중 오류가 발생했습니다.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        logger.e('Status Code: $statusCode');
        logger.e('Response Data: $responseData');

        String message = '알 수 없는 오류가 발생했습니다.';

        final errorReason = responseData?['error']?['errors']?[0]?['reason'];
        if (errorReason == 'quotaExceeded') {
          message = 'YouTube API 사용 한도를 초과했습니다.\n잠시 후 다시 시도해주세요.';
        } else if (responseData?['error']?['message'] != null) {
          message = responseData['error']['message'];
        } else if (responseData?['message'] != null) {
          message = responseData['message'];
        }

        Get.snackbar('오류', message);
      } else {
        Get.snackbar('오류', '네트워크 오류 또는 서버에 연결할 수 없습니다.');
      }
    } catch (e) {
      logger.e('YouTube 검색 오류: $e');
      Get.snackbar('오류', e.toString());
    }

    return {
      'tracks': <YoutubeTrack>[],
      'nextPageToken': null,
      'totalResults': 0,
      'fromCache': false,
    };
  }

  /// YouTube 동영상 길이 조회
  static Future<int?> getYoutubeLength({required String videoId}) async {
    try {
      final response = await dio.get(
        'https://youtube.googleapis.com/youtube/v3/videos',
        queryParameters: {
          "part": "contentDetails",
          "id": videoId,
          "fields": "items(contentDetails(duration))",
          "key": "AIzaSyAeJOrIdbWb7Gg78f56tBBnJN-snpH2CIg",
        },
      );

      final isoDuration =
          response.data['items'][0]['contentDetails']['duration'];
      return _convertIsoDurationToSeconds(isoDuration);
    } catch (e) {
      logger.e('YouTube 길이 조회 오류: $e');
      return null;
    }
  }

  /// ISO 8601 duration을 초 단위로 변환
  static int _convertIsoDurationToSeconds(String isoDuration) {
    try {
      // PT1H2M10S -> 3730초
      final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
      final match = regex.firstMatch(isoDuration);

      if (match == null) return 0;

      final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

      return hours * 3600 + minutes * 60 + seconds;
    } catch (e) {
      logger.e('ISO duration 변환 오류: $e');
      return 0;
    }
  }
}
