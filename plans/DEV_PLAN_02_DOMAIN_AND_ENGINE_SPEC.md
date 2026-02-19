# PopSearch MVP 개발 계획 - 2단계 도메인 및 엔진 스펙

## 목표
- 검색 도메인 규칙을 고정하고 엔진 스펙을 코드로 명세화한다.

## 핵심 작업
- 엔진 모델 정의: Google, YouTube, Naver, Daum, Yahoo
- 엔진 메타데이터 구성:
  - 라벨
  - URL 템플릿
  - 제네릭 아이콘 키(브랜드 자산 비사용)
- 쿼리 URL 인코딩 유틸 구현
- 비제휴 고지 문구 상수화:
  - "Not affiliated with Google, YouTube, Naver, Daum, or Yahoo."

## 산출물
- 엔진 enum/model
- URL 템플릿/빌더 유틸
- URL 생성 단위 테스트

## 완료 기준(DoD)
- 모든 엔진에서 쿼리 인코딩 URL이 정확히 생성됨

## 진행 체크
- [x] 엔진 모델 정의(Google, YouTube, Naver, Daum, Yahoo)
- [x] 엔진 메타데이터(라벨/URL 템플릿/제네릭 아이콘 키) 구성
- [x] 쿼리 URL 인코딩 유틸 구현
- [x] 비제휴 고지 문구 상수화
- [x] URL 생성 단위 테스트 작성
