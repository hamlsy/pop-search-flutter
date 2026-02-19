# PopSearch MVP 개발 계획 - 1단계 프로젝트 셋업

## 목표
- Flutter 기본 템플릿을 PopSearch MVP 구조로 전환 가능한 기반 상태를 만든다.

## 핵심 작업
- 기능 단위 폴더 구조 정의:
  - `lib/app/` (엔트리, 라우팅, 전역 테마)
  - `lib/features/search/` (검색 UI, 엔진 선택, 검색 실행)
  - `lib/features/settings/` (테마 변경, 기록 삭제, 고지 문구)
  - `lib/core/` (도메인 모델, URL 빌더, 실행 서비스, 저장소 인터페이스)
- 플랫폼 정책 확정:
  - iOS: 유료, 무광고, 광고 SDK 미포함
  - Android: 무료, Settings 하단 배너 1개
- 빌드 타깃 방향 문서화:
  - `androidFreeWithAds`
  - `iosPaidNoAds`

## 산출물
- 프로젝트 구조 초안 문서
- 플랫폼/플레이버 정책 체크리스트

## 완료 기준(DoD)
- 기능별 코드 분리가 가능한 골격 확정
- 플랫폼별 수익화/SDK 정책이 명시됨
