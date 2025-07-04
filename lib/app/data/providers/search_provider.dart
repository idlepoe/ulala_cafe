import 'package:get/get.dart';
import '../models/youtube_track_model.dart';
import '../utils/api_service.dart';

class SearchProvider extends GetxController {
  // YouTube 검색 (페이지네이션 지원)
  Future<Map<String, dynamic>> youtubeSearch({
    required String search,
    String? pageToken,
  }) async {
    return await ApiService.youtubeSearch(search: search, pageToken: pageToken);
  }
}
