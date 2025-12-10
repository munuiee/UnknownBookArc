import UIKit

extension UIView {
    
    // 1. 메모리에 저장할 키값들
    private struct AssociatedKeys {
        static var dynamicBorderColor = "dynamicBorderColor"
        static var dynamicShadowColor = "dynamicShadowColor"
    }

    // 2. 앱 실행 시 자동 실행 (Swizzling)
    static let activateDynamicColorSupport: Void = {
        swizzleMethod(original: #selector(traitCollectionDidChange(_:)), swizzled: #selector(swizzled_traitCollectionDidChange(_:)))
        swizzleMethod(original: #selector(layoutSubviews), swizzled: #selector(swizzled_layoutSubviews))
    }()
    
    private static func swizzleMethod(original: Selector, swizzled: Selector) {
        guard let originalMethod = class_getInstanceMethod(UIView.self, original),
              let swizzledMethod = class_getInstanceMethod(UIView.self, swizzled) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    // 3. 변수 설정 (값을 넣으면 기능 활성화)
    public var dynamicBorder: UIColor? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.dynamicBorderColor) as? UIColor }
        set {
            UIView.activateDynamicColorSupport
            objc_setAssociatedObject(self, &AssociatedKeys.dynamicBorderColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateDynamicColors()
        }
    }
    
    public var dynamicShadow: UIColor? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.dynamicShadowColor) as? UIColor }
        set {
            UIView.activateDynamicColorSupport
            objc_setAssociatedObject(self, &AssociatedKeys.dynamicShadowColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateDynamicColors()
        }
    }

    // 4. 색상 업데이트 로직
    private func updateDynamicColors() {
        if let border = self.dynamicBorder {
            self.layer.borderColor = border.resolvedColor(with: self.traitCollection).cgColor
        }
        if let shadow = self.dynamicShadow {
            self.layer.shadowColor = shadow.resolvedColor(with: self.traitCollection).cgColor
        }
    }

    // 5. 모드 변경 감지
    @objc func swizzled_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.swizzled_traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateDynamicColors()

            if self.dynamicShadow != nil {
                self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            }
        }
    }

    
    // 6. 화면 그려질 때 "강제 교정" 로직
    @objc func swizzled_layoutSubviews() {
        self.swizzled_layoutSubviews()

        if self.dynamicBorder != nil {
            // 기존 처리
            if let textField = self as? UITextField {
                if textField.borderStyle == .roundedRect {
                    textField.borderStyle = .none
                    if textField.layer.cornerRadius == 0 { textField.layer.cornerRadius = 6 }
                    if textField.layer.borderWidth == 0 { textField.layer.borderWidth = 1 }
                }
            }

            if self is UIImageView {
                if self.layer.borderWidth == 0 { self.layer.borderWidth = 1 }
            }

            updateDynamicColors()
        }

        // shadow가 설정된 경우 shadowPath를 강제로 갱신
        if self.dynamicShadow != nil {
            // shadowPath가 없거나 bounds가 변경된 경우 재설정
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath

            // 업데이트 반영
            updateDynamicColors()
        }
    }

    
    
}
