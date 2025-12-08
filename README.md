<img width="1000" alt="표지" src="https://github.com/user-attachments/assets/ccbeef01-60aa-45ab-9618-474fc9ada787" />

<br>
 
## 기획 의도
교환 독서, 독서 인증 등 확산되는 독서 문화에 맞춰 필요한 기능만 담은 직관적인 앱을 통해 부담 없이 편하게 책을 즐길 수 있도록 합니다.
새로운 책과 지식을 만나는 설렘과 그 속에서의 성장을 기록하는 공간이라는 의미를 갖고 있는 ‘낯선책방’은 여러 독서 기록 어플을 사용해오면서 느꼈던 불편함을 개선하고, 오로지 필요한 기능만 담아 가볍고 부담없이 독서 기록을 즐기고 싶다는 의도에서 탄생하게 되었습니다. 

<br>

‘낯선 책방’이라는 이름에는 새로운 책을 만날 때의 신비로움, 그리고 처음 접하는 지식을 기록해 나가는 기대감을 담고 있습니다. 책을 읽는 일은 곧 미지의 세계로 떠나는 여행과도 같습니다. 익숙하지 않은 시대의 역사와 문화를 발견하기도 하고, 한 번도 살아보지 않은 삶을 잠시나마 체험하기도 합니다. 책은 결국 경험이며, 독자는 그 경험을 통해 이전과는 다른 시야와 감정을 갖게 됩니다. 그래서 ‘낯섦’은 단지 어색함이 아니라, 성장을 이끄는 출발점이라고 생각했습니다. 이러한 의미를 담아, 사용자가 책을 통해 마주하는 모든 낯섦을 기록하고 쌓아 갈 수 있는 공간이라는 뜻으로 ‘낯선 책방’이라는 이름을 선택하게 되었습니다.

<br>

<div align="center"> 

| 👥 주요 사용자 | 🔄 앱의 방향 |
|-------|--------|
|나이불문 꾸준히 독서 기록을 즐기는 사용자<br> 처음으로 독서 기록에 도전하는 사용자 | 기록 과정을 최소화한 입력 흐름<br> 문장 및 강정 기록 + 장르별 책 정보로 구성된 기록 구조<br> 누구나 바로 사용할 수 있는 가볍고 직관적인 UI |

<br>
</div>



## 팀

<div align="center"> 
 
| 🧑🏻‍🎨 강솔이 | 👩‍💻 김리하   | 👩‍💻 변지혜     | 👩‍💻 박혜연      |
|-------------|-------------|--------------|-------------|
| <div align="center">[@strongtoothbrush](https://github.com/strongtoothbrush)</div> | <div align="center">[@meowbyterh](https://github.com/meowbyterh)</div>  | <div align="center">[@munuiee](https://github.com/munuiee)</div> | <div align="center">[@104hyeon](https://github.com/104hyeon)</div> |
| 전체 UI/UX 디자인 | 메인 화면 및 책장 구현 | 저널 및 좋아요 구현 | 추가화면 및 편집화면 구현 |

<br>
</div>

## 팀 목표
우리 팀은 MVVM 아키텍처를 기반으로 읽기 좋은 구조를 갖춘 독서 기록 앱을 구현하는 것을 목표로 하며, 특히 네트워크 처리 영역에는 RxSwift를 선택적으로 적용해 비동기 흐름을 명확하고 일관되게 다루는 것을 핵심 강점으로 삼았습니다. 전체 프로젝트에 무리하게 RxSwift를 확산시키기보다, 실제 효과가 큰 API 통신 영역에 집중 적용하여 구현 난이도를 조절하면서도 코드 품질을 높였습니다. 이를 통해 팀원 모두가 이해할 수 있는 구조적인 코드, 그리고 유지보수성과 확장성이 뛰어난 프로젝트 환경 을 만드는 것을 팀의 최종 목표로 삼고 있습니다.


## 주요 기능
<img width="4414" height="3462" alt="주요기능_메인, 책장" src="https://github.com/user-attachments/assets/a880e12a-eea6-47f4-8fcd-056685ae762f" />

- 메인화면: 사용자가 원하는 책을 검색하거나 직접 입력해 손쉽게 추가할 수 있습니다. 추가한 책은 읽을 예정, 읽는 중, 잠시 멈춘, 완독한 책 총 네 가지 상태로 나누어 한눈에 관리할 수 있습니다.
- 책 추가 화면: 알라딘 API를 연결하여 제목이나 작가, 출판사로 책 정보를 빠르게 불러올 수 있습니다. 또한 서점에 등록되지 않은 책을 읽는 경우 직접 추가하기 버튼을 통하여 썸네일 이미지 및 책의 상세 정보를 직접 입력할 수 있습니다.
- 책 편집 화면: 책의 상태를 수정하고, 진행률을 등록하여 진행바를 통해 독서 진행률을 확인할 수 있습니다.
- 책장: 사용자가 저장한 책을 한눈에 볼 수 있는 공간으로, 장르별 태그를 기준으로 자동 분류되며 책장 내 검색 기능을 통해 등록된 책을 찾을 수 있습니다.

<img width="4414" height="3462" alt="주요기능_저널, 좋아요" src="https://github.com/user-attachments/assets/f90753d8-a365-43c4-990e-4145034beec9" />

- 문단 수집: 페이지 정보를 등록하고 여러 문단을 인용 혹은 발췌하여 정리할 수 있습니다. 오래 기억하고 싶은 문단에는 좋아요를 눌러 좋아요 페이지에서 모아볼 수 있습니다.
- 찰나의 기록: 책을 읽으면서 떠오르는 실시간 생각과 감정을 짧게 기록할 수 있도록 만들었으며, 타임라인 형식을 적용해 흐름을 따라가기 쉽도록 했습니다.
- 좋아요: 좋아요를 누른 문단 수집 또는 책을 한공간에서 확인할 수 있습니다.


<br>

<div align="center"> 


| 메인화면 | 책 추가하기 | 책장 |
|--------|----------|-----|
|![메인화면 시연영상](https://github.com/user-attachments/assets/8f336776-44bc-492a-8132-970e5338800f) | ![추가 시연영상](https://github.com/user-attachments/assets/25f618df-b64c-4cd2-bdfc-3aa7b1e32589) | ![책장 시연영상](https://github.com/user-attachments/assets/4286b0a1-9c4d-4650-828b-2b04d78705d6) |

<br>

| 저널 | 좋아요 | 마이페이지 |
|-----|------|---------|
| ![저널 시연영상](https://github.com/user-attachments/assets/b4d1697f-2eb5-465b-8731-f18560213b51) | ![좋아요 시연영상](https://github.com/user-attachments/assets/87772008-3764-4ab1-8426-5509d8202350) | <img width="720" height="1157" alt="마이페이지" src="https://github.com/user-attachments/assets/161e9a4d-28e8-4e3b-8f56-0841afa3577b" /> |



</div>

<br>






## 아키텍처 및 라이브러리
우리 팀은 프로젝트의 규모와 팀원의 숙련도를 고려하여, 전체 영역에 불필요하게 많은 기술을 도입하기보다는 실제 효과가 큰 곳에 집중하는 방식으로 기술스택을 결정하였습니다. 비동기 처리가 빈번한 API 통신에는 RxSwift를 적용하여 데이터 흐름을 명확하게 관리했고, 화면 구성에는 MVVM 아키텍처를 적용해 View와 로직을 분리함으로써 유지보수성을 높였습니다. 

### MVVM
이 앱은 하나의 데이터 변경이 여러 화면에 동시에 영향을 미치는 구조를 갖고 있어, 기존의 델리게이트나 콜백 방식만으로는 복잡한 데이터 흐름 속에서 데이터 일관성을 유지하는 데 한계가 있었습니다. 이를 해결하기 위해 MVVM 패턴을 도입해 뷰와 비즈니스 로직을 명확히 분리하고, 비동기 데이터 흐름을 선언적으로 처리할 수 있도록 RxSwift를 함께 적용했습니다. 

MVVM 기반 구조에서는 화면 요소보다 비즈니스 로직부터 우선적으로 설계할 수 있기 때문에, 데이터 처리 방식을 먼저 안정적으로 구축한 뒤 화면을 얹는 방식으로 개발을 진행할 수 있었습니다.

또한 RxSwift의 Observable을 통해 상태 변화가 구독 중인 모든 뷰에 즉시 반영되도록 하여, 1대 다수의 데이터 동기화 문제를 효율적으로 해결할 수 있었습니다.

### Environment
<img src="https://img.shields.io/badge/Xcode-1575F9.svg?style=for-the-badge&logo=Xcode&logoColor=white"> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white"> 
### Development
<img src="https://img.shields.io/badge/Swift-F05138.svg?style=for-the-badge&logo=swift&logoColor=white">   

### Design
![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white)

### OS
<img src="https://img.shields.io/badge/iOS-000000.svg?style=for-the-badge&logo=apple&logoColor=white">

### Communication
<img src="https://img.shields.io/badge/slack-4A154B?style=for-the-badge&logo=slack&logoColor=white"> <img src="https://img.shields.io/badge/notion-000000?style=for-the-badge&logo=notion&logoColor=white"> 

### Libraries
[![SnapKit 5.7.1](https://img.shields.io/badge/SnapKit-5.7.1-0A99E2?style=for-the-badge&logo=data:image/svg+xml;base64,여기에인코딩된문자열&logoColor=white)](https://github.com/SnapKit/SnapKit) ![iCloud](https://img.shields.io/badge/icloud-%233693F3.svg?style=for-the-badge&logo=icloud&logoColor=white)





