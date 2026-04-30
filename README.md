
<img width="1920" height="1080" alt="1_표지" src="https://github.com/user-attachments/assets/962b2bc2-38a5-48ad-b342-f97f26d4a3d3" />
<br>

<img width="7611" height="2234" alt="앱스크린_마이페이지 추가" src="https://github.com/user-attachments/assets/9735d86b-6d15-4122-92fd-cdf802714fc3" />

<img width="2155" height="759" alt="장표에 사용한 다크모드 화면" src="https://github.com/user-attachments/assets/d2b6f93e-e48d-441e-9a23-98886e0d3514" />

<br>
<br>

[📱앱스토어 바로가기](https://apps.apple.com/kr/app/%EB%82%AF%EC%84%A0%EC%B1%85%EB%B0%A9/id6756062952)

<br>

## Project Summary
```md
## Project Summary (PM Perspective)

- Problem: 독서 기록 앱들이 기능 과다 및 UI/UX 불일치로 인해 기록 흐름에 집중하기 어렵다는 문제 인식
- Solution: 기록 행동에 집중할 수 있도록 기능을 최소화하고 UI 흐름을 단순화한 독서 기록 앱 설계
- Result: 마케팅 없이 앱스토어 도서 카테고리 54위 달성, UT 기반 UX 및 안정성 업데이트 완료

## Role & Contribution

- Team Lead (PM / iOS Developer)
  - 서비스 기획 및 문제 정의
  - MVP 범위 정의 및 우선순위 설정
  - 일정 관리 및 팀 커뮤니케이션
  - 저널 페이지 핵심 기능 개발
```

## 팀

<div align="center"> 
 
| 🧑🏻‍🎨 강솔이 | 👩‍💻 김리하   | 👩‍💻 변지혜     | 👩‍💻 박혜연      |
|-------------|-------------|--------------|-------------|
| <div align="center">[@strongtoothbrush](https://github.com/strongtoothbrush)</div> | <div align="center">[@meowbyterh](https://github.com/meowbyterh)</div>  | <div align="center">[@munuiee](https://github.com/munuiee)</div> | <div align="center">[@104hyeon](https://github.com/104hyeon)</div> |
| ▫️ UI/UX <br> ▫️ Design System | ▫️ Home <br> ▫️ Library <br> ▫️ Navigation Bar <br> ▫️ Asset Setting | ▫️ Journal <br> ▫️ Liked <br> ▫️ My Page <br> ▫️ DarkMode <br> ▫️ CloudKit | ▫️ API <br> ▫️ Search <br> ▫️ Book Registration <br> ▫️ My Page |

<br>
</div>
 
## 기획 의도
- **나이불문 누구나 편하게 책과 감정을 기록할 수 있는 직관적이고 감각적인 독서 기록 앱**
- 낯선책방은 새로운 책과 지식을 만날 때 느껴지는 신비로움과 기대감을 담은 이름입니다. 책은 익숙하지 않은 세계를 여행하듯 새로운 시대와 삶을 경험하게 하고, 그 과정에서 독자는 이전과 다른 시야를 갖게 됩니다. 그래서 ‘낯섦’을 성장의 시작점으로 보고, 사용자가 그런 경험들을 기록해 쌓아갈 수 있는 공간이라는 의미를 담았습니다.

  
<br>

- 핵심 기능
    - 알라딘 API를 사용한 책 검색 기능을 통해 원하는 책의 정보를 한번에 불러올 수 있습니다.
    - iCloud를 통한 자동 동기화 기능으로 여러 기기에서 같은 정보를 확인할 수 있습니다.
    - 인상깊은 문단을 수집하고, 타임라인 형식으로 감정을 기록할 수 있습니다.
    - 장르별 태그를 통해 책을 필터링하여 장르별로 모아둘 수 있습니다.

<br>

<div align="center"> 

| 👥 주요 사용자 | 🔄 앱의 방향 |
|-------|--------|
|나이불문 꾸준히 독서 기록을 즐기는 사용자<br> 처음으로 독서 기록에 도전하는 사용자 | 기록 과정을 최소화한 입력 흐름<br> 문장 및 강정 기록 + 장르별 책 정보로 구성된 기록 구조<br> 누구나 바로 사용할 수 있는 가볍고 직관적인 UI |

<br>
</div>




## 팀 목표
우리 팀은 MVVM 아키텍처를 기반으로 읽기 좋은 구조를 갖춘 독서 기록 앱을 구현하는 것을 목표로 하며, 특히 네트워크 처리 영역에는 RxSwift를 선택적으로 적용해 비동기 흐름을 명확하고 일관되게 다루는 것을 핵심 강점으로 삼았습니다. 전체 프로젝트에 무리하게 RxSwift를 확산시키기보다, 실제 효과가 큰 API 통신 영역에 집중 적용하여 구현 난이도를 조절하면서도 코드 품질을 높였습니다. 이를 통해 팀원 모두가 이해할 수 있는 구조적인 코드, 그리고 유지보수성과 확장성이 뛰어난 프로젝트 환경 을 만드는 것을 팀의 최종 목표로 삼고 있습니다.

<br>

## 개인별 개발로그
👉 [Development Log](https://shining-polo-563.notion.site/2aa470d98ef58031838ff1c630859c6d?source=copy_link)

<br>


## 주요 기능
📎 [낯선책방 주요 기능 소개](https://power-ketch-e9a.notion.site/2cd7e11137998011a467f54fef1003c1?source=copy_link)

<br>

<div align="center"> 


| 메인화면 | 책 추가하기 | 책장 |
|--------|----------|-----|
|![메인화면](https://github.com/user-attachments/assets/a5f17304-d7cb-48e8-8c95-6aef5ab396c2) | ![책 추가하기](https://github.com/user-attachments/assets/0e1c7991-9203-4478-886b-e7872dc857b1) | ![책장](https://github.com/user-attachments/assets/da1121ad-f5bf-4e1e-9fd7-d28e51dafc8a) |

<br>

| 저널 | 좋아요 | 마이페이지 |
|-----|------|---------|
| ![저널](https://github.com/user-attachments/assets/72398534-bd48-46d7-b94a-329d287f13a5) | ![좋아요](https://github.com/user-attachments/assets/51efffec-ec62-4865-ac3c-ae171064beaf) | ![마이페이지](https://github.com/user-attachments/assets/93e0e874-815d-407a-b48d-d00184627e03) |


</div>

<br>






## 아키텍처 및 라이브러리
![11 아키텍처 및 라이브러리](https://github.com/user-attachments/assets/7872222a-eb3c-48e9-b428-ff183171304a)

 
```swift
iOS: 16.0+
Architecture: MVVM
Reactive: RxSwift(API)
UI: UIkit, SnapKit
Data: CoreData, CloudKit
```



우리 팀은 프로젝트의 규모와 팀원의 숙련도를 고려하여, 전체 영역에 불필요하게 많은 기술을 도입하기보다는 실제 효과가 큰 곳에 집중하는 방식으로 기술스택을 결정하였습니다. 비동기 처리가 빈번한 API 통신에는 RxSwift를 적용하여 데이터 흐름을 명확하게 관리했고, 화면 구성에는 MVVM 아키텍처를 적용해 View와 로직을 분리함으로써 유지보수성을 높였습니다. 

<br>


### MVVM
여러 화면에 동시에 영향을 미치는 데이터 구조를 안정적으로 관리하기 위해 MVVM 패턴과 RxSwift를 도입했습니다. 뷰와 비즈니스 로직을 분리하고, Observable 기반 데이터 바인딩으로 상태 변화를 모든 화면에 즉시 반영했습니다. 이를 통해 복잡한 데이터 흐름에서도 일관성과 확장성을 확보할 수 있었습니다.

<br>


### CloudKit
CloudKit을 도입해 별도의 서버 없이 Apple ID 기반 데이터 저장 및 기기 간 동기화를 구현했습니다.
Core Data와 연동하여 관리 부담을 줄이면서도, Apple이 제공하는 암호화로 개인정보 보안을 강화했습니다.

<br>

## 디자인 시스템
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/d5a4e098-bd37-4d7a-b304-a5876822b00e" />
네이비와 화이트의 강한 대비를 활용해 브랜드의 핵심 감정인 낯섦을 직관적으로 표현했습니다. <br>
메인 컬러로 네이비를 선택한 이유는, 시간이 지나 새롭게 느껴지는 문장처럼 깊고 차분한 분위기를 표현하기 위해서 입니다. <br>
로고는 책에서 만나는 새로운 공간을 표현했고, 아이콘은 24px 기준으로 만들었습니다. 마진값은 20px, 버튼 사이즈는 ios 터치 아리아 권장 사이즈 44포인트이상인 52px로, 컴포넌트는 4배수 기준으로 제작했습니다.

<br>
<br>

## Updates (Post-Launch)
## 버전 정보

| 버전 | 설명 |
| --- | --- |
| 1.0.0 | 핵심 기능을 갖춘 MVP 버전 |
| 1.0.1 | 긴 책 제목이 표시될 때 버튼이 가려지는 문제를 해결했습니다. |
| 1.0.2 | 일부 메타데이터를 수정했습니다. |
| 1.1.1 | 마이페이지가 추가되고 다크 모드를 사용할 수 있습니다. <br> 이와 함께 전반적인 안정성 향상을 위해 버그를 수정하였습니다. |
| 1.1.2 | 홈 화면 디자인을 일부 개선했습니다. |
| 1.1.4 | 새로운 ‘연도별 통계’ 기능으로 한 해의 변화를 한눈에 확인해보세요. |
| 1.1.6 | 기록한 문장을 쉽게 복사할 수 있는 버튼을 추가했어요. |
| 1.2 | 카메라로 책 페이지를 스캔하여 텍스트를 자동 인식하는 OCR 기능을 추가했어요. <br> AI가 인식된 텍스트를 자동으로 교정해줍니다. |

<br>

### 🔍 Data-Driven Operations: Firebase 퍼널 트래킹 환경 구축

MVP 단계에서 데이터 로그 설계를 후순위로 둔 점이 가장 큰 아쉬움으로 남아, 출시 후 우선순위로 재조정하여 직접 구축했습니다.

**목표:** 핵심 유저 여정인 `검색 → 기록` 퍼널의 단계별 전환율과 이탈 지점 정량 파악

**구현:**
- Firebase Analytics 연동
- 핵심 행동 단위 이벤트 정의 (검색 시작, 책 선택, 기록 진입, 기록 완료 등)
- 퍼널 전환율 및 단계별 이탈 지점 트래킹

**의의:** 다음 개선 우선순위를 감이 아닌 데이터로 결정할 수 있는 환경 확보

<br>

### 🤖 OCR x LLM 자동교정 (v1.2, 2026.04)
기존 MVP에서 '런칭 후 고도화'로 분류했던 OCR 기능을 핵심 가치 기준으로 우선순위 재조정하여, 직접 설계·구현하고 업데이트 심사를 통과시켰습니다.

**문제:** OCR 인식 오류로 수동 교정이 새로운 마찰을 만들어 스캔 기능의 의미가 상실됨

**해결:** 스캔 → OCR → Claude API 자동 교정 → 깨끗한 텍스트 흐름 설계

**트레이드오프:**
- API 비용 발생 → OCR 원본 폴백 구조로 사용량 한도 초과 시에도 기록 차단 안 됨
- '기록 마찰 제거'라는 핵심 가치 직결 → 비용 트레이드오프 감수, 시장 반응 우선 검증

<br>

## UT Feedback
저희는 구글폼 1회, 메이즈 2회 총 2차로 나누어 UT를 진행하여 의견을 수집하였습니다.
**자세한 내용은 아래 통계자료 링크에서 확인하실 수 있습니다.**

### 📑 1·2차 UT 통계자료
[낯선책방 UT 통계자료](https://power-ketch-e9a.notion.site/UT-2cb7e1113799803d8fdee15f914763ea?source=copy_link)

### 🔍 1차 UT 진행 중 수집된 피드백
- 독서 진행도를 수정하는 방식이 더 편했으면 좋겠어요.
- 홈화면에서 보이는 진행도를 클릭하면 바로 수정할 수 있을 줄 알았어요
- 책을 검색해서 저널로 가는 것이 어려웠어요
- 책 검색 시 똑같은 결과가 무한 반복 되어 불편했어요
- 저장 버튼이 작아서 인식이 어려웠어요

### ‼️ 1차 UT 진행 중 발견된 대표적인 에러
- 찰나의 기록 전송창이 7줄 넘어가면 스크롤이 안 되는 문제 <br>
👉 찰나의 기록 전송창에서 텍스트 입력이 7줄을 넘어갈 경우 스크롤이 되지 않아 이후 내용이 보이지 않던 문제를 수정하여, 긴 글 입력 시에도 정상적으로 스크롤되고 모든 텍스트가 표시되도록 개선했습니다.
- 책이 추가한 순으로 정렬되지 않은 문제 <br>
👉 책 목록의 정렬 기준을 전면 개편하여, 모든 항목이 최근 추가된 순서대로 표시되도록 변경했습니다.

- 검색 시 여러 책이 중복되어 결과가 나오는 문제 <br>
👉 검색 API가 단일 페이지 데이터만 반복적으로 불러오는 문제로 스크롤 시 상단 결과가 중복 노출되던 오류를 수정하여, 연속적인 검색 결과가 정상적으로 표시되도록 개선했습니다.





