# PopSearch 프로젝트 구조 초안

## 앱 모듈
- `pop_search/lib/main.dart`: 앱 엔트리
- `pop_search/lib/app/`: 앱 루트, 라우팅, 전역 테마

## 기능 모듈
- `pop_search/lib/features/search/`: 검색 화면 및 검색 관련 도메인
- `pop_search/lib/features/settings/`: 설정 화면

## 코어 모듈
- `pop_search/lib/core/repositories/`: 저장소 인터페이스
- `pop_search/lib/core/services/`: 실행 서비스 인터페이스

## 테스트
- `pop_search/test/`: 위젯/단위 테스트 엔트리

## 향후 확장 방향
- `lib/features/search/domain/`: 엔진 모델, URL 빌더 연동
- `lib/core/constants/`: 고지 문구/정책 상수
- `lib/core/utils/`: URL/인코딩 유틸
