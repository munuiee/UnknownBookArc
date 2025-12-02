import UIKit
import SnapKit

final class SplashViewController: UIViewController {
        
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "splashImage")
        return imageView
    }()
    
    private let mainLabel: UILabel =  {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "책방지기님,\n 반가워요!"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        [logoImage, mainLabel].forEach { view.addSubview($0) }
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
            make.top.equalToSuperview().offset(212)
        }
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImage.snp.bottom).offset(24)
        }
    }

}
