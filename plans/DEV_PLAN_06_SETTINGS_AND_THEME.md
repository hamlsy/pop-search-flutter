# PopSearch MVP 개발 계획 - 6단계 Settings 및 테마

## 목표
- MVP 설정 기능(테마/히스토리/고지)을 완성한다.

## 핵심 작업
- Settings 화면 구현:
  - ThemeMode: System, Light, Dark
  - Clear History
  - 비제휴 고지 문구
- 테마 저장/복원 연결
- 라이트/다크 가독성/대비 점검

## 산출물
- SettingsScreen
- ThemeController/ThemeRepository

## 완료 기준(DoD)
- 테마 변경이 즉시 반영되고 재실행 후 유지
- 기록 삭제가 최근 검색 리스트에 즉시 반영

## 진행 체크
- [x] Settings 화면 구현(ThemeMode/System-Light-Dark, Clear History, 비제휴 고지)
- [x] ThemeController/ThemeRepository 구현 및 저장/복원 연결
- [x] 테마 변경 즉시 반영(MaterialApp themeMode 연결)
- [x] 기록 삭제 즉시 반영(설정 화면에서 Clear History 호출 시 검색 화면 동기화)
- [x] 라이트/다크 가독성 대비 보정(검색 화면 색상 분기)
