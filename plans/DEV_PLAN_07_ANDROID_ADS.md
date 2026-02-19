# PopSearch MVP 개발 계획 - 7단계 Android 광고 통합

## 목표
- Android에서만 비방해 배너 광고를 정책 준수 형태로 적용한다.

## 핵심 작업
- Android 전용 광고 모듈 통합(`google_mobile_ads` 등)
- 광고 위치 고정: Settings 하단
- 고정 높이 컨테이너로 레이아웃 점프 방지
- 광고 로드 실패 시 graceful fallback 적용
- 금지사항 준수 확인:
  - 검색 입력/Go 주변 배치 금지
  - 인터스티셜/리워드/스플래시 금지

## 산출물
- Android 전용 Banner 위젯
- 광고 정책 검증 체크리스트

## 완료 기준(DoD)
- Android에서만 Settings 하단 배너 1개 노출
- 핵심 검색 플로우 중 방해/오동작 없음
