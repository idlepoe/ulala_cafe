// 환경변수 설정
export const config = {
  youtube: {
    apiKey: process.env.YOUTUBE_API_KEY || 'AIzaSyAaqL6l2BNLbwDZ8aCh_Tr8MYLdXIsRdAI',
  },
  firebase: {
    projectId: process.env.FIREBASE_PROJECT_ID,
  },
}; 