# TODO - Dice Arena (Flutter 재구성)

## 1) 요구사항 확정
- [x] 기본 문서(dice_arena_codex.md) 화면 흐름 확인
- [x] “완전 새로 만들기”에서 이전 코드는 lib/ 전체 재구성으로 처리하기로 결정(2번)
- [x] 화면을 Home→CharacterSelect→SkillSelect→BuildConfirm→ReadySummary 5개로 분리하기

## 2) 구현 계획 확정
- [ ] 새 폴더 구조 결정 (domain/data/presentation)
- [ ] 앱 상태 모델(선택 캐릭터/HP/추가스킬/ready 체크) 정의

## 3) 코드 작성
- [ ] 기존 lib/ 제거 및 새 lib/ 생성
- [ ] 데이터(샘플 캐릭터/스킬/다이 페이스) seed 추가
- [ ] 라우팅 및 5개 화면 UI 구현
- [ ] 상태 전파/갱신(선택 변경 시 HP/스킬 기본값 반영)
- [ ] 공유 위젯들(패널, 섹션타이틀, 캐릭터 카드/칩, 다이 타일, 스킬 타일, 헬스 다이얼) 구현

## 4) 검증
- [ ] flutter analyze
- [ ] flutter run
- [ ] 화면 플로우 정상 동작 확인

