// MARK: UIColor 코드 모음집

import UIKit

extension UIColor {
    
    // 프라이머리
    static let primaryColor = UIColor(red: 0.08, green: 0.145, blue: 0.331, alpha: 1)
    //
    static let basicBackground = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1)
    
    // 독서 상태 버튼 용
    static let stateDefaultBGColor = UIColor.white
    static let stateDefaultBorderColor = UIColor(red: 0.903, green: 0.901, blue: 0.901, alpha: 1)
    static let stateDefaultTextColor = UIColor(red: 0.505, green: 0.495, blue: 0.495, alpha: 1)
    static let stateSeletedTextColor = UIColor(red: 0.303, green: 0.297, blue: 0.297, alpha: 1)
    static let readingSelected =  UIColor(red: 0.604, green: 0.756, blue: 0.674, alpha: 1)
    static let pausedSelected = UIColor(red: 0.992, green: 0.671, blue: 0.675, alpha: 1)
    static let finishedSelected = UIColor(red: 0.694, green: 0.754, blue: 0.926, alpha: 1)
    static let scheduledSelected = UIColor(red: 0.968, green: 0.889, blue: 0.605, alpha: 1)
    
    // 책 유형 버튼 용
    static let formatDefaultBGColor = UIColor.white
    static let formatDefaultBorderColor =  UIColor(red: 0.903, green: 0.901, blue: 0.901, alpha: 1)
    static let formatDefaultTextColor = UIColor(red: 0.705, green: 0.699, blue: 0.699, alpha: 1)
    static let paperBGColor = UIColor(red: 0.855, green: 0.883, blue: 0.965, alpha: 1)
    static let paperTextColor = UIColor(red: 0.533, green: 0.624, blue: 0.887, alpha: 1)
    static let ebookBGColor = UIColor(red: 0.852, green: 0.908, blue: 0.878, alpha: 1)
    static let ebookTextColor = UIColor(red: 0.604, green: 0.756, blue: 0.674, alpha: 1)
    
    // 장르 태그 버튼 용
    static let tagSeletedTextColor = UIColor(red: 0.211, green: 0.365, blue: 0.809, alpha: 1)
    static let tagSeletedBoarderColor = UIColor(red: 0.533, green: 0.624, blue: 0.887, alpha: 1)
    static let tagSeletedBGColor = UIColor(red: 0.968, green: 0.974, blue: 0.992, alpha: 1)


    // 독서 홈 상단 배너
    static let readinHomeBannerColor = UIColor(red: 0.855, green: 0.882, blue: 0.965, alpha: 1)
    
    // 책 추가하기 버튼
    static let addBookButtonColor = UIColor(red: 0.082, green: 0.145, blue: 0.333, alpha: 1)
    
    // 홈 화면 회색
    static let readingHomeGrayColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)



    static let colorCDCBCB = UIColor(red: 0.8039, green: 0.7961, blue: 0.7961, alpha: 1.0)
    static let color676565 = UIColor(red: 0.404, green: 0.396, blue: 0.396, alpha: 1.0)
    static let colorB4B2B2 = UIColor(red: 0.706, green: 0.698, blue: 0.698, alpha: 1.0)
    static let colorFCFCFC = UIColor(red: 0.988235, green: 0.988235, blue: 0.988235, alpha: 1.0)
    static let colorFAFAFA = UIColor(red: 0.980392, green: 0.980392, blue: 0.980392, alpha: 1.0)
    static let color0B142D = UIColor(red: 0.043, green: 0.078, blue: 0.176, alpha: 1.0)

    static let color152555 = UIColor(red: 0.082, green: 0.145, blue: 0.333, alpha: 1.0)
    static let colorE6E6E6 = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1.0)
    
    // 시작일
    static let colorF9FBFA = UIColor(red: 0.976, green: 0.984, blue: 0.980, alpha: 1.0) // 배경
    static let color7BAD92 = UIColor(red: 0.482, green: 0.678, blue: 0.573, alpha: 1.0)

    // 종료일
    static let colorF7F8FD = UIColor(red: 0.969, green: 0.973, blue: 0.992, alpha: 1.0)
    static let color5F7ED8 = UIColor(red: 0.373, green: 0.494, blue: 0.847, alpha: 1.0)



    // 책 선택 (종이책/전자책)
    static let colorD9E6ED = UIColor(red: 0.851, green: 0.902, blue: 0.929, alpha: 1.0) // 배경
    static let color3F7088 = UIColor(red: 0.247, green: 0.439, blue: 0.533, alpha: 1.0) // 글자

    /* 읽음 상태 버튼 (배경/글자 순)*/
    // 완독
    static let colorDAE1F6 = UIColor(red: 0.855, green: 0.882, blue: 0.965, alpha: 1.0)
    static let color1F387F = UIColor(red: 0.122, green: 0.220, blue: 0.498, alpha: 1.0) // + 현재 읽는 중 진행률 텍스트


    // 읽는 중
    static let colorD9E8E0 = UIColor(red: 0.851, green: 0.910, blue: 0.878, alpha: 1.0)
    static let color375846 = UIColor(red: 0.216, green: 0.345, blue: 0.275, alpha: 1.0)

    // 중단
    static let colorFEDCDD = UIColor(red: 0.996, green: 0.863, blue: 0.867, alpha: 1.0)
    static let colorA40509 = UIColor(red: 0.643, green: 0.020, blue: 0.035, alpha: 1.0)
    
    // 읽을 예정
    static let colorFBF0CB = UIColor(red: 0.984, green: 0.941, blue: 0.796, alpha: 1.0)
    static let colorB9920E = UIColor(red: 0.725, green: 0.573, blue: 0.055, alpha: 1.0)

    // 글자색
    static let color1A1919 = UIColor(red: 0.102, green: 0.098, blue: 0.098, alpha: 1.0)
    static let color365DCE = UIColor(red: 54/255, green: 93/255, blue: 206/255, alpha: 1)

    static let color889FE2 = UIColor(red: 136/255, green: 159/255, blue: 226/255, alpha: 1.0)
    
    static let color817E7E = UIColor(red: 129/255, green: 126/255, blue: 126/255, alpha: 1)


}
