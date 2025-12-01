// MARK: "확인", "취소" 있는 알럿 베이스
import UIKit

extension UIViewController {
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
