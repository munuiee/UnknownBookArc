<img width="1000" alt="표지" src="https://github.com/user-attachments/assets/ccbeef01-60aa-45ab-9618-474fc9ada787" />

<br>

<img width="7611" height="2234" alt="앱스크린_마이페이지 추가" src="https://github.com/user-attachments/assets/9735d86b-6d15-4122-92fd-cdf802714fc3" />

<img width="2155" height="759" alt="장표에 사용한 다크모드 화면" src="https://github.com/user-attachments/assets/d2b6f93e-e48d-441e-9a23-98886e0d3514" />



## 팀

<div align="center"> 
 
| 🧑🏻‍🎨 강솔이 | 👩‍💻 김리하   | 👩‍💻 변지혜     | 👩‍💻 박혜연      |
|-------------|-------------|--------------|-------------|
| <div align="center">[@strongtoothbrush](https://github.com/strongtoothbrush)</div> | <div align="center">[@meowbyterh](https://github.com/meowbyterh)</div>  | <div align="center">[@munuiee](https://github.com/munuiee)</div> | <div align="center">[@104hyeon](https://github.com/104hyeon)</div> |
| 전체 UI/UX 디자인 | 메인 화면 및 책장 구현 | 저널 및 좋아요 구현 | 추가화면 및 편집화면 구현 |

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


## 주요 기능
📎 [낯선책방 주요 기능 소개](https://tulip-bronze-600.notion.site/2c8badea375980bf8573df7d65de842f?source=copy_link)

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
![12 디자인시스템](https://github.com/user-attachments/assets/27adc13e-0458-41c8-be93-936e87f2bb21)
네이비와 화이트의 강한 대비를 활용해 브랜드의 핵심 감정인 **낯섦**을 직관적으로 표현했습니다. <br>
메인 컬러로 네이비를 선택한 이유는, 시간이 지나 새롭게 느껴지는 문장처럼 깊고 차분한 분위기를 표현하기 위해서 입니다. <br>
로고는 책에서 만나는 새로운 공간을 표현했고, 아이콘은 24px 기준으로 만들었습니다. 마진값은 20px, 버튼 사이즈는 ios 터치 아리아 권장 사이즈 44포인트이상인 52px로, 컴포넌트는 4배수 기준으로 제작했습니다.

<br>

## UT Feedback
저희는 구글폼 1회, 메이즈 2회 총 2차로 나누어 UT를 진행하여 의견을 수집하였습니다.

**🔍 1차 UT 진행 중 수집된 피드백**
- 독서 진행도를 수정하는 방식이 더 편했으면 좋겠어요.
- 홈화면에서 보이는 진행도를 클릭하면 바로 수정할 수 있을 줄 알았어요
- 책을 검색해서 저널로 가는 것이 어려웠어요
- 책 검색 시 똑같은 결과가 무한 반복 되어 불편했어요
- 저장 버튼이 작아서 인식이 어려웠어요

**1차 UT 진행 중 발견된 에러**
- 찰나의 기록 전송창이 7줄 넘어가면 스크롤이 안 되는 문제
- 책이 추가한 순으로 정렬되지 않은 문제
- 검색 시 여러 책이 중복되어 결과가 나오는 문제



**🧪 1-2차 UT 이후 개선사항**



