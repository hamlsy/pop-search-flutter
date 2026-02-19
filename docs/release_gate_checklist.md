# 테스트 및 릴리즈 게이트 체크리스트

## 자동 검증 루틴
- [x] `flutter analyze`
- [x] `flutter build web --release`
- [ ] `flutter test -r compact` (현재 CI/로컬 환경의 isolate 이슈로 재시도 필요)

## 테스트 스위트 범위
- [x] URL 빌더 단위 테스트
- [x] 저장소 단위 테스트(엔진/히스토리)
- [x] 테마 컨트롤러 단위 테스트
- [x] 검색 플로우 위젯 테스트(Enter/Go 경로)
- [x] 핸드오프 서비스 단위 테스트(YouTube 폴백)

## 수동 QA 시나리오 (Flow A~E)
- [x] Flow A: 앱 실행 직후 즉시 입력/검색 가능
- [x] Flow B: 엔진 전환 후 검색 URL 정확성 확인
- [x] Flow C: YouTube 앱 미설치 상태에서 웹 폴백 확인
- [x] Flow D: 최근 검색 저장/재사용/개별 삭제/전체 삭제 확인
- [x] Flow E: 설정에서 테마 변경 즉시 반영 및 재실행 유지 확인
