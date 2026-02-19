# 플랫폼/플레이버 정책 체크리스트

## 수익화 정책
- [x] iOS: 유료, 무광고, 광고 SDK 미포함
- [x] Android: 무료, Settings 하단 배너 1개

## 빌드 타깃 방향
- [x] `androidFreeWithAds`
- [x] `iosPaidNoAds`

## 구현 원칙
- [x] iOS 바이너리에서 광고 SDK 의존성 제외
- [x] Android 광고 노출 위치를 Settings 하단으로 제한
- [x] 검색 핵심 UX는 플랫폼별 동일 동작 유지
