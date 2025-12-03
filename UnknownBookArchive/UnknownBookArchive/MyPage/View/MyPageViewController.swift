// MARK: 마이페이지

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    private let myPageTitle = UILabel()
    private let topView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        myPageTitle.text = "마이페이지"
        myPageTitle.font = UIFont.semiBoldFont(ofSize: 18)
        
        view.addSubview(topView)
        topView.addSubview(myPageTitle)
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        
        myPageTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
        }
        

    }
    
}
