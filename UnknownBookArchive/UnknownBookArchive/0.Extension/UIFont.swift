// MARK: UIFont

import UIKit

struct FontName {
    static let pretendardRegular = "Pretendard-Regular"
    static let pretendardMedium = "Pretendard-Medium"
    static let pretendardSemiBold = "Pretendard-SemiBold"
    static let pretendardBold = "Pretendard-Bold"
}

extension UIFont {
    class func regularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.pretendardRegular, size: size)!
    }
    
    class func mediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.pretendardMedium, size: size)!
    }
    
    class func semiBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.pretendardSemiBold, size: size)!
    }
    
    class func boldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.pretendardBold, size: size)!
    }
}


