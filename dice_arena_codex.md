# Dice Arena Companion App - 소프트웨어 설계 기술서 (SDD)

## 1. 개요 (Introduction)

### 1.1 목적 (Purpose)
본 문서는 주사위 기반 카드 게임 'Dice Arena'의 컴패니언 앱(Companion App) 개발을 위한 소프트웨어 설계 기술서이다. 이 앱은 물리적인 보드게임과 연동되어 캐릭터 관리, 스킬 선택 및 최종 빌드 확인 등의 디지털 지원 기능을 제공하며, 플레이어에게 효율적인 게임 세팅 및 진행을 돕는 것을 목적으로 한다.

### 1.2 범위 (Scope)
**포함되는 기능:**
*   캐릭터 선택 및 정보 표시
*   스킬 선택 및 관리
*   최종 세팅(빌드) 확인 및 요약
*   선택된 캐릭터 및 스킬 데이터 저장 및 불러오기

**제외되는 기능:**
*   실제 주사위 굴림, 카드 사용, 전투 계산 등 물리적 게임 플레이 로직
*   네트워크 멀티플레이 기능 (향후 고려 가능)
*   사용자 인증 및 계정 관리

### 1.3 용어, 약어 및 약칭 (Definitions, Acronyms, and Abbreviations)
*   **컴패니언 앱 (Companion App):** 물리적 게임을 보조하는 디지털 애플리케이션.
*   **SDD (Software Design Description):** 소프트웨어 설계 기술서.
*   **UI (User Interface):** 사용자 인터페이스.
*   **UX (User Experience):** 사용자 경험.

### 1.4 참고 자료 (References)
*   다이스쓰론 (Dice Throne)
*   파이널타이탄 (Final Titan)
*   투매니본즈 (Too Many Bones)

### 1.5 문서 개요 (Overview)
본 문서는 'Dice Arena' 컴패니언 앱의 전체적인 소프트웨어 아키텍처, 상세 설계, 기술 스택, 개발 계획 및 핵심 철학을 기술한다.

## 2. 시스템 아키텍처 (System Architecture)

### 2.1 고수준 아키텍처 (High-Level Architecture)
'Dice Arena' 컴패니언 앱은 사용자 인터페이스(UI), 데이터 관리 레이어, 그리고 핵심 로직 레이어로 구성된다. 이 앱은 물리적인 게임과 분리되어 작동하며, 물리적 게임은 실제 주사위와 카드를 통해 진행된다. 앱은 게임 세팅 및 캐릭터 정보 표시 역할에 집중한다.

### 2.2 구성 요소 다이어그램 (Component Diagram)
```mermaid
graph TD
    A[사용자] -->|조작| B(Dice Arena Companion App)
    B -->|데이터 표시/조작| C[UI 레이어]
    C -->|요청| D{핵심 로직 레이어}
    D -->|데이터 저장/조회| E[데이터 관리 레이어]
    E -->|JSON 데이터| F[로컬 저장소]
    A -->|실제 주사위 굴림/카드 사용| G[물리적 게임 (오프라인)]
    G -->|결과 확인| A
```
*   **UI 레이어:** 사용자에게 정보를 표시하고 입력을 받는다. (Home, CharacterSelect, SkillSelect, BuildConfirm, ReadySummary 등)
*   **핵심 로직 레이어:** 캐릭터 및 스킬 선택, 최종 빌드 구성 등의 비즈니스 로직을 처리한다.
*   **데이터 관리 레이어:** `diceTypes`, `characters`, `skills` 등의 JSON 데이터를 관리한다.
*   **로컬 저장소:** 앱의 설정 및 사용자 선택 데이터를 저장한다.

### 2.3 앱과 물리적 게임 간 상호작용 (Interaction between App and Physical Game)
컴패니언 앱은 물리적 게임 플레이의 보조 도구로써 다음과 같은 상호작용을 가진다:
*   **앱 역할:** 캐릭터 선택 및 스킬 선택, 최종 세팅 확인. 캐릭터의 체력 등 상태 관리.
*   **물리적 게임 역할:** 실제 주사위 굴림, 추가 카드 사용, 몬스터/상대 캐릭터와의 전투 진행.
*   **분리된 역할:** 앱은 전투 계산에 관여하지 않으며, 게임의 핵심 규칙(주사위 굴림, 재굴림, 데미지 계산)은 플레이어가 물리적으로 수행한다.

## 3. 상세 설계 (Detailed Design)

### 3.1 UI/UX 설계 (UI/UX Design)

#### 3.1.1 화면 흐름 (Screen Flow)
앱의 주요 화면 흐름은 다음과 같다:
`Home` → `CharacterSelect` → `SkillSelect` → `BuildConfirm` → `ReadySummary`

#### 3.1.2 화면 명세 (Screen Specifications)
*   **Home 화면:** 앱 시작 시 초기 화면.
*   **CharacterSelect (캐릭터 선택) 화면:** 사용 가능한 캐릭터 목록을 표시하고, 플레이어가 캐릭터를 선택할 수 있게 한다. 선택된 캐릭터의 기본 정보(예: 초기 체력, 기본 능력)를 보여준다.
*   **SkillSelect (스킬 선택) 화면:** 선택된 캐릭터에 따라 사용 가능한 스킬 목록을 표시하고, 플레이어가 추가 스킬을 선택할 수 있게 한다.
*   **BuildConfirm (빌드 확인) 화면:** 선택된 캐릭터와 스킬 조합을 요약하여 표시하고, 최종 확인을 요청한다.
*   **ReadySummary (준비 요약) 화면:** 최종 확정된 캐릭터 및 스킬 빌드를 간략하게 보여주어 게임 준비 상태를 확인하게 한다.

### 3.2 데이터 설계 (Data Design)

#### 3.2.1 데이터 모델 (JSON Schemas)
앱은 `diceTypes`, `characters`, `skills` 데이터를 JSON 형식으로 관리한다. 각 데이터 모델의 예시는 다음과 같다:

**Dice Type (주사위 타입):**
```json
// 예시:
// {
//   "id": "D6",
//   "faces": ["Attack", "Defense", "Skill", "Reroll", "Wild", "Blank"]
// }
```

**Character (캐릭터):**
```json
// 예시:
// {
//   "id": "Warrior",
//   "name": "전사",
//   "initialHealth": 20,
//   "baseSkills": ["Sword_Slash", "Shield_Block"]
// }
```

**Skill (스킬):**
```json
// 예시:
// {
//   "id": "Sword_Slash",
//   "name": "검격",
//   "type": "Attack",
//   "cost": {"Skill": 2}, // 스킬 발동에 필요한 주사위 면
//   "description": "적에게 강력한 검격을 날립니다."
// }
```

#### 3.2.2 상태 관리 (State Management)
앱의 핵심 상태는 다음과 같다:
*   `selectedCharacterId`: 현재 선택된 캐릭터의 ID.
*   `selectedExtraSkillIds`: 선택된 추가 스킬들의 ID 목록.
*   `characterCurrentHealth`: 선택된 캐릭터의 현재 체력 (앱에서 조작).

### 3.3 기능 설계 (Functional Design)

#### 3.3.1 핵심 로직 (Core Logic)
*   **캐릭터 선택 로직:** 사용자가 캐릭터를 선택하면, 해당 캐릭터의 기본 스킬 및 초기 체력 정보를 로드하고 앱 상태를 업데이트한다.
*   **스킬 선택 로직:** 사용자가 2개의 추가 스킬을 선택하면, `selectedExtraSkillIds`를 업데이트하고, 최종적으로 선택된 3개의 스킬(기본 스킬 + 추가 스킬) 구성을 관리한다.
*   **빌드 확인 로직:** 선택된 캐릭터와 스킬 정보를 종합하여 사용자에게 최종 빌드 요약을 제공한다.

#### 3.3.2 앱의 역할 및 책임 (App Role and Responsibilities)
*   캐릭터 및 스킬 설정 인터페이스 제공.
*   캐릭터의 체력 등 현재 상태를 기록 및 표시.
*   게임 세팅을 위한 정보(캐릭터, 스킬) 관리 및 표시.
*   전투 계산은 앱의 책임이 아님.

## 4. 기술 스택 및 개발 환경 (Technical Stack and Development Environment)

### 4.1 사용 기술 (Technologies Used)
*   **프론트엔드:** React, TypeScript
*   **상태 관리:** (향후 결정, 예: React Context API, Zustand, Redux)
*   **데이터 형식:** JSON

### 4.2 개발 환경 (Development Environment)
*   React 앱 생성 도구 (예: `create-react-app` 또는 Vite)
*   IDE: (예: VS Code, IntelliJ IDEA)

## 5. 개발 계획 (Development Plan)

### 5.1 개발 우선순위 (Development Priorities)
1.  캐릭터 선택 기능 구현
2.  스킬 선택 기능 구현
3.  최종 빌드 확인 및 요약 화면 구현

## 6. 핵심 철학 (Core Philosophy)
이 앱은 게임 자체가 아닌 '세팅 도구'의 역할을 수행한다. 플레이어가 물리적 게임에 더 집중할 수 있도록, 번거로운 준비 과정을 디지털로 효율화하는 것에 중점을 둔다.
