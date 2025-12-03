// MARK: 탭바 커스텀

import Foundation
import UIKit

final class CustomTabBar: UITabBar {
    private let customHeight: CGFloat = 65
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = customHeight + safeAreaInsets.bottom
        return size
    }
}
