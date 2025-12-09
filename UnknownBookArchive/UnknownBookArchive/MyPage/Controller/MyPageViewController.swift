// MARK: 마이페이지

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = myPageView
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.fetchMonthCompletedCount()
        viewModel.fetchYearCompletedCount()
    }
    
    
    
    // MARK: bind함수
    private func bind() {
        viewModel.monthCompletedCount
            .map { String($0) }
            .bind(to: myPageView.monthCountLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.yearCompletedCount
            .map { String($0) }
            .bind(to: myPageView.yearCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    
}
