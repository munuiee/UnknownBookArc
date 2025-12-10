// MARK: 알럿 베이스

import UIKit

extension UIViewController {
    
    // 확인 버튼만 있는 알럿
    func showAlert(
        title: String,
        message: String,
        confirmTitle: String = "확인",
        completion: (() -> Void)? = nil
    ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            completion?()            
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }


    // 확인, 취소 버튼 있는 알럿
    func showConfirmAlert(
        title: String,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        completion: @escaping () -> Void
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 확인 액션
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            completion()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
