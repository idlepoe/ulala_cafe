# Firebase Functions

## 환경변수 설정

### YouTube API 키 설정

1. **로컬 개발 환경**
   ```bash
   # .env 파일 생성 (functions 폴더 내)
   echo "YOUTUBE_API_KEY=AIzaSyAaqL6l2BNLbwDZ8aCh_Tr8MYLdXIsRdAI" > .env
   ```

2. **Firebase Functions 환경변수 설정**
   ```bash
   firebase functions:config:set youtube.api_key="AIzaSyAaqL6l2BNLbwDZ8aCh_Tr8MYLdXIsRdAI"
   ```

3. **배포**
   ```bash
   firebase deploy --only functions
   ```

## 사용 가능한 함수들

- `youtubeSearch`: YouTube 음악 검색
- `getSearchHistory`: 검색 히스토리 조회

## 개발

```bash
# 의존성 설치
npm install

# 로컬 실행
npm run serve

# 배포
npm run deploy
``` 