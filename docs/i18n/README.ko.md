# claude-code-enhance

> [Claude Code](https://claude.com/claude-code)용 프롬프트 향상기 + 교훈 라이브러리 + 프로젝트 코드맵. 무료, 로컬 실행, MIT 라이선스.

[English](../../README.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · **한국어** · [Русский](README.ru.md)

![demo](../../assets/demo.svg)

세 가지 스킬이 함께 작동하여 AI 코딩 에이전트가 "방금 걸어 들어온 똑똑한 컨설턴트"가 아니라 "18개월 동안 당신의 코드베이스에서 일해온 노련한 엔지니어"처럼 행동하게 만듭니다.

## 무엇을 얻을 수 있나

| 스킬                           | 무엇을 하나                                                                                                    | 언제 작동하나                                                                                                 |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `/enhance <대략적인 아이디어>` | 코드베이스 컨텍스트를 로드하고, 프롬프트 엔지니어링 원칙을 적용하여, 검토/편집/제출할 구조화된 프롬프트를 생성 | 사용자 제어(직접 입력)                                                                                        |
| `consult-scars`                | 아키텍처 계획을 만들기 전에 교훈 라이브러리에서 관련 교훈을 로드                                               | 자동 실행(`design`, `refactor`, `migrate`, `add caching`, `auth` 등 아키텍처 동사가 포함된 프롬프트에서 작동) |
| `/refresh-codemap`             | git 히스토리에서 `hotfiles.md` 및 `recent.md` 재생성                                                           | 사용자 제어(주간 또는 주요 작업 전에 실행)                                                                    |

또한 스킬이 존재할 때 사용하고 존재하지 않을 때 우아하게 저하되는 선택적 인프라(교훈 라이브러리, 코드맵, SessionStart 훅).

## 왜 이것이 필요한가

기존 대안은 솔로 개발자와 소규모 팀에게 실제 단점이 있습니다:

|                            | claude-code-enhance            | Augment Code                 | claude-mem                       |
| -------------------------- | ------------------------------ | ---------------------------- | -------------------------------- |
| **라이선스**               | MIT                            | 독점                         | AGPL-3.0(상업적 독약)            |
| **비용**                   | $0(기존 Claude Code 세션 사용) | 쿼리당 크레딧, 불투명한 가격 | 압축을 위한 API 토큰             |
| **개인정보**               | 모두 로컬, 머신을 떠나지 않음  | 선택적 클라우드 모드         | 로컬 SQLite + Chroma             |
| **종속성**                 | 없음 — 자유롭게 fork           | Augment 인프라               | AGPL 바이러스성 카피레프트       |
| **코드베이스 인식**        | 예(코드맵 + Serena + grep)     | 예                           | 간접(압축 요약)                  |
| **과거 교훈 상호 참조**    | 예(내장 교훈 라이브러리)       | 아니오                       | 아니오(대신 모든 것을 자동 캡처) |
| **향상된 프롬프트 가시성** | 예(검토/편집/폐기)             | 예(Ctrl+P → 버퍼 교체)       | 해당 없음(다른 도구)             |
| **신뢰 모델**              | 감사 가능한 일반 markdown      | 블랙박스 서비스              | AI 압축 요약                     |

철학: **큐레이션 > 캡처**. 기억의 질은 양보다 무한히 더 중요합니다. 시니어 엔지니어의 노트북은 얇고 권위적입니다; 주니어의 노트북은 넘쳐나고 신뢰할 수 없습니다. 이 플러그인은 얇은 노트북입니다.

## 빠른 시작

### 옵션 1 — 플러그인 마켓플레이스(게시 후 권장)

```bash
# Claude Code에서:
/plugin marketplace add tenxengineer/claude-code-enhance
/plugin install claude-code-enhance
```

### 옵션 2 — 수동 설치

```bash
git clone https://github.com/tenxengineer/claude-code-enhance.git
cd claude-code-enhance

mkdir -p ~/.claude/skills
cp -r skills/enhance        ~/.claude/skills/
cp -r skills/consult-scars  ~/.claude/skills/
cp -r skills/refresh-codemap ~/.claude/skills/

# Claude Code 재시작 — 스킬이 /skills 목록에 나타납니다
```

### 옵션 3 — 선택적 인프라가 포함된 전체 설치

```bash
bash scripts/bootstrap.sh
```

bootstrap 스크립트는 멱등성이 있습니다 — 재실행이 안전합니다.

## 사용법

### 모호한 프롬프트 향상

```
/enhance 필드 면적 계산이 잘못되는 버그 수정
```

에이전트는 코드베이스 컨텍스트(`.codemap/`, `~/.claude/lessons/`, 프로젝트 `CLAUDE.md`, Serena MCP가 있는 경우, 최근 git 활동)를 로드하고, 프롬프트 엔지니어링 원칙을 적용하며, 구조화된 향상 프롬프트를 보여줍니다. 당신은:

- **제출** (`s`) — 향상된 버전을 실제 지시로 진행
- **편집** (`e`) — 제출 전에 수정
- **폐기** (`x`) — 원래의 대략적인 의도로 되돌림

## 전체 문서

자세한 내용, 기여 가이드라인 및 고급 구성에 대해서는 영문 [README](../../README.md)를 참조하세요.

## 라이선스

MIT. [LICENSE](../../LICENSE)를 참조하세요.
