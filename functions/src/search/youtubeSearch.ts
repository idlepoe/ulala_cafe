import * as admin from "firebase-admin";
import { onRequest } from "firebase-functions/v2/https";

const db = admin.firestore();

// 환경변수 설정
const config = {
  youtube: {
    apiKey: process.env.YOUTUBE_API_KEY || 'AIzaSyAaqL6l2BNLbwDZ8aCh_Tr8MYLdXIsRdAI',
  },
};

// YouTube API 응답 구조
interface YouTubeSearchResponse {
  items: YouTubeSearchItem[];
  nextPageToken?: string;
  pageInfo: {
    totalResults: number;
    resultsPerPage: number;
  };
}

interface YouTubeSearchItem {
  id: {
    videoId: string;
    kind: string;
  };
  snippet: {
    publishedAt: string;
    channelId: string;
    title: string;
    description: string;
    thumbnails: {
      default: { url: string; width: number; height: number };
      medium: { url: string; width: number; height: number };
      high: { url: string; width: number; height: number };
    };
    channelTitle: string;
    liveBroadcastContent: string;
    publishTime: string;
  };
}

// 검색 결과 구조
interface YoutubeTrack {
  id: string;
  videoId: string;
  title: string;
  description: string;
  thumbnail: string;
  channelTitle: string;
  publishedAt: string;
  duration?: number; // 추후 video details API로 확장
  createdBy: {
    uid: string;
    nickname: string;
    avatarUrl: string;
  };
}

export const youtubeSearch = onRequest({
  cors: true,
  region: "asia-northeast3",
}, async (req, res: any) => {
  if (req.method !== "POST") {
    return res.status(405).json({
      success: false,
      message: "허용되지 않은 요청 방식입니다.",
    });
  }

  try {
    const { search, pageToken } = req.body;
    const maxResults = 50; // 고정값으로 설정

    if (!search || search.trim().length === 0) {
      return res.status(400).json({
        success: false,
        message: "검색어를 입력해주세요.",
      });
    }

    const keyword = search.trim();
    const now = admin.firestore.Timestamp.now();
    const searchHistoryRef = db.collection("search_history");

    // YouTube API 호출 함수
    const callYoutubeAPI = async (withPageToken?: string) => {
      const youtubeApiKey = config.youtube.apiKey;
      const response = await fetch(
        `https://www.googleapis.com/youtube/v3/search?` +
        `q=${encodeURIComponent(keyword)}&` +
        `part=snippet&` +
        `maxResults=${maxResults}&` +
        `key=${youtubeApiKey}&` +
        `order=relevance&` +
        `type=video&` +
        `videoEmbeddable=true` +
        (withPageToken ? `&pageToken=${withPageToken}` : '')
      );

      if (!response.ok) {
        const errorData = await response.json();
        let message = "YouTube API 호출 중 오류가 발생했습니다.";

        if (errorData.error?.errors?.[0]?.reason === "quotaExceeded") {
          message = "YouTube API 사용 한도를 초과했습니다. 잠시 후 다시 시도해주세요.";
        } else if (errorData.error?.message) {
          message = errorData.error.message;
        }

        throw new Error(message);
      }

      return await response.json() as YouTubeSearchResponse;
    };

    // 검색 결과 파싱 함수 (중복 제거)
    const parseSearchResults = (data: YouTubeSearchResponse) => {
      const results: YoutubeTrack[] = [];
      const seen = new Set<string>();

      for (const item of data.items) {
        if (item.id?.videoId && item.snippet && !seen.has(item.id.videoId)) {
          seen.add(item.id.videoId);
          const decodeHtml = (html: string): string => {
            return html
              .replace(/&amp;/g, "&")
              .replace(/&lt;/g, "<")
              .replace(/&gt;/g, ">")
              .replace(/&quot;/g, '"')
              .replace(/&#39;/g, "'")
              .replace(/&nbsp;/g, " ");
          };

          results.push({
            id: item.id.videoId,
            videoId: item.id.videoId,
            title: decodeHtml(item.snippet.title || ""),
            description: decodeHtml(item.snippet.description || ""),
            thumbnail: item.snippet.thumbnails?.medium?.url || 
                      item.snippet.thumbnails?.default?.url || "",
            channelTitle: item.snippet.channelTitle || "",
            publishedAt: item.snippet.publishedAt || "",
            createdBy: {
              uid: "system",
              nickname: "YouTube Search",
              avatarUrl: "",
            },
          });
        }
      }
      return results;
    };

    // 히스토리 저장 함수
    const saveToHistory = async (results: YoutubeTrack[], totalResults: number) => {
      const searchHistoryData = {
        id: `${keyword.toLowerCase()}_${Date.now()}`,
        keyword: keyword.toLowerCase(),
        results,
        searchedAt: now,
        totalResults,
      };
      await searchHistoryRef.doc(searchHistoryData.id).set(searchHistoryData);
    };

    try {
      // pageToken이 있는 경우: YouTube API로 직접 검색
      if (pageToken) {
        const data = await callYoutubeAPI(pageToken);
        const results = parseSearchResults(data);
        
        // 검색 결과 히스토리에 저장
        await saveToHistory(results, data.pageInfo?.totalResults || 0);

        return res.status(200).json({
          success: true,
          message: "YouTube 검색이 완료되었습니다.",
          data: results,
          fromCache: false,
          totalResults: data.pageInfo?.totalResults || 0,
          nextPageToken: data.nextPageToken,
        });
      }

      // pageToken이 없는 경우: 히스토리 먼저 확인
      const existingSearch = await searchHistoryRef
        .where("keyword", "==", keyword.toLowerCase())
        .orderBy("searchedAt", "desc")
        .limit(1)
        .get();

      if (!existingSearch.empty) {
        const lastSearch = existingSearch.docs[0];
        const lastSearchData = lastSearch.data();
        const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
        
        if (lastSearchData.searchedAt.toDate() > thirtyDaysAgo) {
          // 히스토리에서 중복 제거
          const uniqueTracks: YoutubeTrack[] = [];
          const seen = new Set<string>();
          for (const track of lastSearchData.results) {
            if (!seen.has(track.videoId)) {
              seen.add(track.videoId);
              uniqueTracks.push(track);
            }
          }

          return res.status(200).json({
            success: true,
            message: "검색 히스토리에서 결과를 가져왔습니다.",
            data: uniqueTracks,
            fromCache: true,
          });
        }
      }

      // 히스토리에 없거나 오래된 경우: YouTube API로 검색
      const data = await callYoutubeAPI();
      const results = parseSearchResults(data);
      
      // 검색 결과 히스토리에 저장
      await saveToHistory(results, data.pageInfo?.totalResults || 0);

      return res.status(200).json({
        success: true,
        message: "YouTube 검색이 완료되었습니다.",
        data: results,
        fromCache: false,
        totalResults: data.pageInfo?.totalResults || 0,
        nextPageToken: data.nextPageToken,
      });

    } catch (error) {
      console.error("❌ YouTube 검색 오류:", error);
      return res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : "서버 오류가 발생했습니다.",
      });
    }
  } catch (error) {
    console.error("❌ YouTube 검색 오류:", error);
    return res.status(500).json({
      success: false,
      message: "서버 오류가 발생했습니다.",
    });
  }
}); 