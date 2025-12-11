// MARK: 라이트모드와 다크모드

import Foundation
import UIKit

extension UIColor {
    
    
    // hex
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >>  8) & 0xFF) / 255.0
        let b = CGFloat((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
      }
    
    static func dynamic(light: String, dark: String, alpha: CGFloat = 1.0) -> UIColor {
        UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(hex: dark, alpha: alpha)
            default:
                return UIColor(hex: light, alpha: alpha)
            }
        }
    }
    
}

enum ColorHex {
    static let white = "FFFFFF"
    static let black = "000000"
    
    static let primaryBlue50 = "F7F8FD"
    static let primaryBlue100 = "DAE1F6"
    static let primaryBlue200 = "B1C0EC"
    static let primaryBlue300 = "889FE2"
    static let primaryBlue400 = "5F7ED8"
    static let primaryBlue500 = "365DCE"
    static let primaryBlue600 = "294AA8"
    static let primaryBlue700 = "1F387F"
    static let primaryBlue800 = "152555"
    static let primaryBlue900 = "0B142D"
    
    static let tertiaryGreen50 = "F9FBFA"
    static let tertiaryGreen100 = "D9E8E0"
    static let tertiaryGreen200 = "BAD4C6"
    static let tertiaryGreen300 = "9AC1AC"
    static let tertiaryGreen400 = "7BAD92"
    static let tertiaryGreen500 = "5D9778"
    static let tertiaryGreen600 = "4A785F"
    static let tertiaryGreen700 = "375846"
    static let tertiaryGreen800 = "23392D"
    static let tertiaryGreen900 = "101914"
    
    static let secondaryTurquoise50 = "FCFDFD"
    static let secondaryTurquoise100 = "D9E6ED"
    static let secondaryTurquoise200 = "B6D0DD"
    static let secondaryTurquoise300 = "93BACD"
    static let secondaryTurquoise400 = "70A3BD"
    static let secondaryTurquoise500 = "4F8DAB"
    static let secondaryTurquoise600 = "3F7088"
    static let secondaryTurquoise700 = "2F5365"
    static let secondaryTurquoise800 = "1F3642"
    static let secondaryTurquoise900 = "0F1A1F"
    
    static let gray50 = "FAFAFA"
    static let gray100 = "E6E6E6"
    static let gray200 = "CDCBCB"
    static let gray300 = "B4B2B2"
    static let gray400 = "9A9898"
    static let gray500 = "817E7E"
    static let gray600 = "676565"
    static let gray700 = "4D4C4C"
    static let gray800 = "343232"
    static let gray900 = "1A1919"
}

extension UIColor {
    
    // MARK: 🌀 중복 컬러
    
    // 0. 배경
    static let backgroundModeColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark: ColorHex.black
    )
    
    // 0-1. 스플래시 배경
    static let splashBGColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark: "0B142D"
    )
    
    // 0-1-1. 스플래시 텍스트
    static let splashTextColor: UIColor = .dynamic(
        light: ColorHex.black,
        dark: ColorHex.gray100
    )
    
    // 1. 프라이머리 primaryBlue800
    static let primary: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue800
    )
    
    // 2. 뒤로가기 버튼 / 상단 탭바 타이틀 / 아이콘
    static let topColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray50
    )
    
    // 3. 저장 버튼
    static let saveColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    // 4. 책 제목
    static let bookTitleColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue900,
        dark:  ColorHex.gray200
    )
    
    // 5. 책 썸네일 테두리
    static let bookBorderColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray700
    )
    
    
    // MARK: 🌀 메인 화면
    
    // 1. 현재 읽는 중 카드 섹션
    static let mainCardSection: UIColor = .dynamic(
        light: ColorHex.primaryBlue100,
        dark:  ColorHex.primaryBlue800
    )
    
    // 1-1. 작가
    static let mainAuthorColor: UIColor = .dynamic(
        light: ColorHex.gray200,
        dark:  ColorHex.gray200
    )
    
    // 1-2. 날짜
    static let mainDateColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray200
    )
    
    // 1-3. 진행률 텍스트
    static let mainPercentTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue700,
        dark:  ColorHex.primaryBlue100
    )
    
    // 1-4. 진행바 진행도
    static let mainProgressBarColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.gray300
    )
    
    // 1-5. 진행바 배경
    static let mainProgressBarBGColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray700
    )
    
    // 1-6. 저널 보기 버튼
    static let mainJournalButtonColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue100,
        dark:  ColorHex.primaryBlue700
    )
    
    // 1-7. 저널 보기 버튼 텍스트
    static let mainJournalTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    // 1-8. 현재 읽는 중 더보기 버튼
    static let mainMoreButtonColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue600,
        dark:  ColorHex.gray500
    )
    
    // 1-9. 현재 읽는 책이 없을 경우 섹션 배경
    static let mainEmptyStateBGColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.primaryBlue900
    )
    
    // 1-9-1. 현재 읽는 책이 없을 경우 섹션 텍스트
    static let mainEmptyTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue900,
        dark:  ColorHex.gray200
    )
    
    // 1-9-2. 현재 읽는 책이 없을 경우 서브 텍스트
    static let mainEmptySubTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray300
    )
    
    // 2. 책방지기 텍스트 폰트
    static let mainTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue900,
        dark:  ColorHex.gray50
    )
    
    // 2-1. 책 추가하기 버튼
    static let mainAddButtonColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    // 2-2. 책 추가하기 버튼 텍스트
    static let mainAddButtonTextColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.primaryBlue800
    )
    
    // 3. 책이 없는 경우의 섹션
    static let mainEmptySection: UIColor = .dynamic(
        light: ColorHex.gray50,
        dark:  ColorHex.gray900
    )
    
    // 3-1. 외곽선
    static let mainESBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    // 3-2. 텍스트
    static let mainESTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray500
    )
    
    // 4. 더보기
    static let mainUnderMoreButton: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray500
    )
    
    // 5. 섹션별 제목 라벨
    static let mainLabelColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue900,
        dark:  ColorHex.gray50
    )
    
    // 6. 썸네일 외곽선
    static let mainThumbnailBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray700
    )
    
    // 7. 테이블뷰 배경
    static let mainTableBGColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 8. 테이블뷰 테두리
    static let mainTableBordercolor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray900
    )
    
    // 8-1. 테이블뷰 작가
    static let tableAuthorColor: UIColor = .dynamic(
        light: ColorHex.gray500,
        dark:  ColorHex.gray200
    )
    
    
    
    // MARK: 🌀 탭바
    
    // 1. 비선택
    static let unselectedTab: UIColor = .dynamic(
        light: ColorHex.gray200,
        dark:  ColorHex.gray600
    )
    
    // 2. 선택
    static let selectedTab: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.gray200
    )
    
    // 3. 배경
    static let backgroundTab: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.black
    )
    
    
    // MARK: 🌀 검색 화면
    
    // 1. 검색바 배경
    static let searchBarBGColor: UIColor = .dynamic(
        light: ColorHex.gray50,
        dark:  ColorHex.gray900
    )
    
    // 1-1. 검색바 아이콘
    static let searchBarIconColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray200
    )
    
    // 1-2. 검색바 플레이스 홀더
    static let searchPlaceholderColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray200
    )
    
    // 1-3. 검색바 x 버튼
    static let searchXButtonColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark: ColorHex.gray300
    )
    
    // 2. "직접 책을 추가하고 싶으신가요?" 텍스트
    static let addTextColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray500
    )
    
    // 3. 직접 책 추가하기 버튼 배경
    static let addButtonBGColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue100,
        dark:  ColorHex.gray900
    )
    
    // 3-1. 직접 책 추가하기 버튼 멘트 라벨
    static let addBookMentLabelColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue200
    )
    
    // 4. 검색 입력 라벨
    static let searchInputLabelColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray200
    )
    
    // 5. 검색 결과 없음 라벨
    static let searchEmptyResultLabelColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray500
    )
    
    // 6. 검색 결과 없을 때 책 추가하기 버튼 배경
    static let searchEmptyAddButtonColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    // 6-1. 검색 결과 없을 때 책 추가하기 버튼 텍스트
    static let searchEmptyAddButtonTextColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.primaryBlue800
    )
    
    // 7. 검색 결과 셀 테두리
    static let searchResultCellBorderColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray900
    )
    
    // 7-1. 검색결과 셀 배경
    static let searchCellBGColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 8. 책 셀 - 작가
    static let bookCellAuthorColor: UIColor = .dynamic(
        light: ColorHex.gray500,
        dark:  ColorHex.gray200
    )
    
    // 9. 책 셀 - 출판사
    static let bookCellPublisherColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray200
    )
    
    
    // MARK: 🌀 진행도 수정
    
    // 1. 진행도 텍스트필드 배경(채우기)
    static let progressTextFieldBackground: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 2. 진행도 텍스트필드 외곽선(border)
    static let progressTextFieldBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray900
    )
    
    // 3. 진행도 텍스트필드 플레이스홀더
    static let progressTextFieldPlaceholderColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray600
    )
    
    
    
    // MARK: 🌀 책 편집화면
    // 1-1. 썸네일 배경(채우기)
    static let thumbnailBackgroundColor: UIColor = .dynamic(
        light: ColorHex.gray50,
        dark:  ColorHex.gray900
    )
    
    // 1-2. 썸네일 외곽선(border)
    static let thumbnailBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    // 1-3. 썸네일 아이콘
    static let thumbnailIconColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray700
    )
    
    
    // 2. 텍스트필드(검색용 등 또 다른 필드) ---------------------------------
    
    // 2-1. 텍스트필드 채우기
    static let textField2Background: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 2-2. 텍스트필드 외곽선
    static let textField2BorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray900
    )
    
    // 2-3. 텍스트필드 플레이스홀더
    static let textField2PlaceholderColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray600
    )
    
    
    // 3. 토글 ---------------------------------------------------------------
    
    // 3-1. 토글 배경
    static let toggleBackgroundColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue100,
        dark:  ColorHex.gray900
    )
    
    // 3-2. 토글 선택된 배경
    static let toggleSelectedBackgroundColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue700
    )
    
    // 3-3. 토글 선택된 텍스트
    static let toggleSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.primaryBlue50
    )
    
    // 3-4. 토글 비선택 텍스트
    static let toggleUnselectedTextColor: UIColor = .dynamic(
        light: ColorHex.gray500,
        dark:  ColorHex.gray500
    )
    
    
    // MARK: 🌀 태그
    
    // 0. 비선택 --------------------------------------------------------------
    
    // 0-1. 비선택 배경(채우기)
    static let unselectedFillColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 0-2. 비선택 외곽선
    static let unselectedBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    // 0-3. 비선택 텍스트
    static let unselectedTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray500
    )
    
    
    // 1. 읽는 중 선택 --------------------------------------------------------
    
    // 1-1. 읽는 중 선택 배경(채우기)
    static let readingSelectedFillColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen100,
        dark:  ColorHex.gray800
    )
    
    // 1-2. 읽는 중 선택 텍스트
    static let readingSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen700,
        dark:  ColorHex.tertiaryGreen300
    )
    
    
    // 3. 중단 선택 -----------------------------------------------------------
    
    // 3-1. 중단 선택 배경 (hex 직접 기입)
    static let pausedSelectedFillColor: UIColor = .dynamic(
        light: "FEDCDD",
        dark:  ColorHex.gray800
    )
    
    // 3-2. 중단 선택 텍스트
    static let pausedSelectedTextColor: UIColor = .dynamic(
        light: "A40509",
        dark:  "FDABAD"
    )
    
    
    // 4. 완독 선택 -----------------------------------------------------------
    
    // 4-1. 완독 선택 배경
    static let finishedSelectedFillColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue100,
        dark:  ColorHex.gray800
    )
    
    // 4-2. 완독 선택 텍스트
    static let finishedSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue700,
        dark:  ColorHex.primaryBlue200
    )
    
    
    // 5. 읽을 예정 선택 -------------------------------------------------------
    
    // 5-1. 읽을 예정 선택 배경
    static let willReadSelectedFillColor: UIColor = .dynamic(
        light: "FBF0CB",
        dark:  ColorHex.gray800
    )
    
    // 5-2. 읽을 예정 선택 텍스트
    static let willReadSelectedTextColor: UIColor = .dynamic(
        light: "B9920E",
        dark:  "B9920E"
    )
    
    
    // 6. 시작일 비선택 --------------------------------------------------------
    
    // 6-1. 시작일 비선택 배경
    static let startDateUnselectedFillColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen50,
        dark:  ColorHex.gray900
    )
    
    // 6-2. 시작일 비선택 외곽선
    static let startDateUnselectedBorderColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen100,
        dark:  ColorHex.gray800
    )
    
    // 6-3. 시작일 비선택 텍스트
    static let startDateUnselectedTextColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen400,
        dark:  ColorHex.tertiaryGreen300
    )
    
    
    // 6-1. 시작일 선택 --------------------------------------------------------
    
    // 6-1-1. 시작일 선택 배경
    static let startDateSelectedFillColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen50,
        dark:  ColorHex.gray800
    )
    
    // 6-1-2. 시작일 선택 외곽선
    static let startDateSelectedBorderColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen100,
        dark:  ColorHex.tertiaryGreen300
    )
    
    // 6-1-3. 시작일 선택 텍스트
    static let startDateSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.tertiaryGreen600,
        dark:  ColorHex.tertiaryGreen300
    )
    
    
    // 7. 종료일 비선택 --------------------------------------------------------
    
    // 7-1. 종료일 비선택 배경
    static let endDateUnselectedFillColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray900
    )
    
    // 7-2. 종료일 비선택 외곽선
    static let endDateUnselectedBorderColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue100,
        dark:  ColorHex.gray800
    )
    
    // 7-3. 종료일 비선택 텍스트
    static let endDateUnselectedTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue400,
        dark:  ColorHex.primaryBlue300
    )
    
    
    // 7-1. 종료일 선택 --------------------------------------------------------
    
    // 7-1-1. 종료일 선택 배경
    static let endDateSelectedFillColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray800
    )
    
    // 7-1-2. 종료일 선택 외곽선
    static let endDateSelectedBorderColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue100,
        dark:  ColorHex.primaryBlue300
    )
    
    // 7-1-3. 종료일 선택 텍스트
    static let endDateSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue600,
        dark:  ColorHex.primaryBlue300
    )
    
    
    // 8. 종이책/전자책 비선택 --------------------------------------------------
    
    // 8-1. 비선택 배경
    static let bookTypeUnselectedFillColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 8-2. 비선택 외곽선
    static let bookTypeUnselectedBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    // 8-3. 비선택 텍스트
    static let bookTypeUnselectedTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray500
    )
    
    
    // 8-1. 종이책/전자책 선택 ---------------------------------------------------
    
    // 8-1-1. 선택 배경
    static let bookTypeSelectedFillColor: UIColor = .dynamic(
        light: ColorHex.secondaryTurquoise100,
        dark:  ColorHex.gray800
    )
    
    // 8-1-2. 선택 텍스트
    static let bookTypeSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.secondaryTurquoise600,
        dark:  ColorHex.secondaryTurquoise400
    )
    
    
    // 9. 장르 태그 비선택 ------------------------------------------------------
    
    // 9-1. 비선택 배경
    static let genreTagUnselectedFillColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 9-2. 비선택 외곽선
    static let genreTagUnselectedBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    // 9-3. 비선택 텍스트
    static let genreTagUnselectedTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray500
    )
    
    
    // 9-1. 장르 태그 선택 ------------------------------------------------------
    
    // 9-1-1. 선택 배경
    static let genreTagSelectedFillColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray800
    )
    
    // 9-1-2. 선택 외곽선
    static let genreTagSelectedBorderColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue300,
        dark:  ColorHex.primaryBlue300
    )
    
    // 9-1-3. 선택 텍스트
    static let genreTagSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue500,
        dark:  ColorHex.primaryBlue300
    )
    
    
    // MARK: 🌀 상세화면
    // 1. 책 제목 ---------------------------------------------------------------
    static let bookTitleTextColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray50
    )
    
    
    // 2. 책 작가 ---------------------------------------------------------------
    static let bookAuthorTextColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray50
    )
    
    
    // 3. 책 출판사 --------------------------------------------------------------
    static let bookPublisherTextColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray50
    )
    
    
    // 4. 진행바 ---------------------------------------------------------------
    
    // 4-1. 진행바 배경
    static let progressBarBackgroundColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    // 4-2. 진행바 채움(프로그레스)
    static let progressBarFillColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    
    // 5. 진행바 페이지 라벨 ----------------------------------------------------
    
    // 5-1. 현재 페이지
    static let progressCurrentPageTextColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray50
    )
    
    // 5-2. 전체 페이지
    static let progressTotalPageTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray700
    )
    
    
    // 6. 좋아요 버튼 -----------------------------------------------------------
    
    // 6-1. 좋아요 버튼 배경
    static let likeButtonBackgroundColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.primaryBlue700
    )
    
    // 6-2. 좋아요 버튼 아이콘/하트
    static let likeButtonIconColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    
    // 7. 저널 보기 버튼 --------------------------------------------------------
    
    // 7-1. 배경
    static let journalButtonBackgroundColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    // 7-2. 텍스트
    static let journalButtonTextColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.primaryBlue800
    )
    
    
    // MARK: 🌀 저널/좋아요
    // 문단 수집 / 찰나의 기록 --------------------------------------------------
    
    // 1. 문단수집/찰나의 기록 탭 텍스트 및 바 선택
    static let recordTabSelectedTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.gray100
    )
    
    // 1-1. 텍스트 및 바 비선택
    static let recordTabUnselectedTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray700
    )
    
    
    // 1-0. 문단수집/찰나의 기록 탭 선택 바 밑배경
    static let recordTabSelectedBarBackgroundColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.gray100
    )
    
    // 1-1. 텍스트 및 바 비선택 - 배경
    static let recordTabUnselectedFillColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray700
    )
    
    
    // 2. 문단 수집 셀 테두리 / 배경 --------------------------------------------
    
    // 2-1. 문단 수집 셀 테두리
    static let paragraphCellBorderColor: UIColor = .dynamic(
        light: ColorHex.gray200,
        dark:  ColorHex.gray800
    )
    
    // 2-2. 문단 수집 셀 배경
    static let paragraphCellBackgroundColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    
    // 3. 페이지수, 멀티버튼 -----------------------------------------------------
    
    static let paragraphPageAndMultiButtonTextColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray500
    )
    
    
    // 4. 텍스트 -----------------------------------------------------------------
    
    static let paragraphTextColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray100
    )
    
    
    // 5. 날짜 -------------------------------------------------------------------
    
    static let paragraphDateTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray500
    )
    
    
    // 6. 좋아요 버튼 ------------------------------------------------------------
    
    static let paragraphLikeButtonIconColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    static let paragraphUnlikeButtonIconColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.primaryBlue100
    )
    
    
    // 7. 찰나의 기록 셀 안 바 --------------------------------------------------------------
    
    // 7-1. 셀 안 바 (가로 라인 등)
    static let paragraphInnerBarColor: UIColor = .dynamic(
        light: "000000",
        dark:  "000000",
        alpha: 0.1
    )
    
    
    // 8. 좋아요 책 썸네일 -------------------------------------------------------
    
    static let likedBookThumbnailBackgroundColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    
    // 9. 좋아요 셀 -------------------------------------------------------
    // 9-1. 책 제목
    static let likedTitleColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray500
    )
    
    // 9-2. 책 작가
    static let likedAuthorColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray300
    )
    
    // 9-3. 날짜
    static let likedDateColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray500
    )
    
    // 9-4. 셀 배경
    static let likedCellColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    // 9-5. 셀 테두리
    static let likedCellBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
  
    
    
    // 편집 ----------------------------------------------------------------------
    
    // 1. 텍스트 배경
    static let editTextBackgroundColor: UIColor = .dynamic(
        light: ColorHex.gray50,
        dark:  ColorHex.gray900
    )
    
    // 2. 플레이스 홀더
    static let editPlaceholderTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray300
    )
    
    // 3. 선택 외곽선
    static let editSelectedBorderColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray200
    )
    
    // 4. 텍스트 컬러
    static let editTextColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray50
    )
    
    
    // 찰나의 기록 --------------------------------------------------------------
    
    // 1. 날짜 (배지 형태)
    static let momentDateBadgeBackgroundColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray900
    )
    
    static let momentDateBadgeTextColor: UIColor = .dynamic(
        light: ColorHex.gray200,
        dark:  ColorHex.gray500
    )
    
    
    // 2. 멀티버튼
    static let momentMultiButtonTextColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray300
    )
    
    
    // 3. 텍스트
    static let momentTextColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray200
    )
    
    
    // 4. 시간
    static let momentTimeTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray300
    )
    
    
    // 5. 페이지수
    static let momentPageTextColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray300
    )
    
    
    // 6. 외곽선
    static let momentCellBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    
    // 그림자 있음 ㅠㅠ ----------------------------------------------------------
    
    // 7. 전송 버튼 비선택
    static let sendButtonDisabledBackgroundColor: UIColor = .dynamic(
        light: ColorHex.gray50,
        dark:  ColorHex.gray800
    )
    
    static let sendButtonDisabledIconColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray100
    )
    
    
    // 8. 전송 버튼 선택
    static let sendButtonEnabledBackgroundColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue700,
        dark:  ColorHex.primaryBlue700
    )
    
    static let sendButtonEnabledTextColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.white
    )
    
    
    // 9. 전송창 ------------------------------------------------------------------
    
    // 9-1. 전송창 입력 영역(버블) 배경
    static let sendInputBackgroundColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray800
    )
    
    static let shadowColor: UIColor = .dynamic(
        light: ColorHex.black,
        dark: ColorHex.gray800,
        alpha: 0.1)
    
    // 9-1. 플레이스홀더
    static let sendInputPlaceholderTextColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray600
    )
    
    
    // 9-2. 텍스트필드 / 뷰 구분선
    static let sendInputSeparatorColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray600
    )
    
    
    // MARK: 🌀 책장
    // 1. 검색바 ---------------------------------------------------------------
    
    // 1-1. 검색바 배경(채우기)
    static let searchBarBackgroundColor: UIColor = .dynamic(
        light: ColorHex.gray50,
        dark:  ColorHex.gray900
    )
    
    // 1-2. 검색바 플레이스홀더
    static let searchBarPlaceholderColor: UIColor = .dynamic(
        light: ColorHex.gray300,
        dark:  ColorHex.gray200
    )
    
    // 1-3. 검색바 아이콘
    static let shelfSearchBarIconColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray200
    )
    
    // 썸네일 테두리
    static let searchBarThumbnailColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray700
    )
    
    // 2. 책 제목 ---------------------------------------------------------------
    
    static let searchBookTitleColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue900,
        dark:  ColorHex.gray200
    )
    
    
    // 3. 책 작가 ---------------------------------------------------------------
    
    static let searchBookAuthorColor: UIColor = .dynamic(
        light: ColorHex.gray500,
        dark:  ColorHex.gray200
    )
    
    
    // 4. 외곽선 ---------------------------------------------------------------
    
    static let searchResultBorderColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray900
    )
    
    // 5. 외곽선 ---------------------------------------------------------------
    
    static let searchResultBGColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.gray900
    )
    
    
    // MARK: 🌀 마이페이지
    // 1. 라벨 -------------------------------------------------------------------
    
    static let myPageLabelColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray50
    )
    
    
    // 2. 활동 내역 라벨 -----------------------------------------------------------
    
    // 2-1. 활동 내역 라벨 배경(채우기)
    static let activityLabelBackgroundColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray800
    )
    
    // 2-2. 활동 내역 라벨 텍스트
    static let activityLabelTextColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue800,
        dark:  ColorHex.primaryBlue100
    )
    
    
    // 3. 완독한 책 통계 ----------------------------------------------------------
    
    // 3-1. 통계 외곽선
    static let statsBorderColor: UIColor = .dynamic(
        light: ColorHex.gray100,
        dark:  ColorHex.gray800
    )
    
    // 3-2. 통계 설명 텍스트
    static let statsDescriptionTextColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray400
    )
    
    // 3-3. 통계 숫자
    static let statsNumberTextColor: UIColor = .dynamic(
        light: ColorHex.gray900,
        dark:  ColorHex.gray50
    )
    
    
    // 4. 버튼 --------------------------------------------------------------------
    
    // 4-1. 버튼 텍스트
    static let myPageButtonTextColor: UIColor = .dynamic(
        light: ColorHex.gray600,
        dark:  ColorHex.gray400
    )
    
    // 4-2. 버튼 외곽선
    static let myPageButtonBorderColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray800
    )
    
    // 4-3. 버튼 아이콘 채우기
    static let myPageButtonIconFillColor: UIColor = .dynamic(
        light: ColorHex.gray200,
        dark:  ColorHex.gray200
    )
    
    // 4-4. 버튼 선택 상태 배경(채우기)
    static let myPageButtonSelectedFillColor: UIColor = .dynamic(
        light: ColorHex.primaryBlue50,
        dark:  ColorHex.gray50
    )
    
    // 4-5. 버튼 클릭 후 배경
    static let myPageButtonSelectedAfterColor: UIColor = .dynamic(
        light: ColorHex.white,
        dark:  ColorHex.black
    )
    
}
