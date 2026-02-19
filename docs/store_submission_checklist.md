# 스토어 제출 체크리스트 완료본

## iOS 준비
- [x] 유료 앱 정책 고정(USD 1 인접 가격 티어 가이드 반영)
- [x] 광고 SDK 미포함 정책 문서화
- [ ] App Store Connect 가격/세금 실제 설정 (릴리즈 계정 작업 필요)

## Android 준비
- [x] Data Safety 초안 반영(로컬 저장 + 광고 SDK 범위)
- [x] 광고 정책 재검증(비방해/비기만, Settings 하단 단일 배너)
- [x] 검색 핵심 플로우에서 광고 비개입 확인

## 공통 정합성
- [x] 개인정보 처리 문구 정리(로컬 저장 항목, Android 광고 SDK)
- [x] 비제휴 고지 문구와 앱 내 표시 일치
- [x] 스토어 설명/스크린샷 반영용 카피 초안 준비

## RC 빌드 상태
- [x] Web release build 생성 (`flutter build web --release`)
- [ ] Android/iOS 스토어 서명 빌드 생성 (서명 키/맥 빌드 환경 필요)
