// MARK: 하단 탭바

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private var lastSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar(), forKey: "tabBar")
        setupTabs()
        setupTabBarAppearance()
        delegate = self
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.backgroundTab
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        
        
        // 색상 설정
        let normal = appearance.stackedLayoutAppearance.normal
        normal.titleTextAttributes = [.foregroundColor: UIColor.unselectedTab]
        
        let selected = appearance.stackedLayoutAppearance.selected
        selected.titleTextAttributes = [.foregroundColor: UIColor.selectedTab]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = .selectedTab
        tabBar.unselectedItemTintColor = UIColor.unselectedTab
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupTabs() {
        
        let coreDataManager = CoreDataManager()
        let myPageViewModel = MyPageViewModel(coreDataManager: coreDataManager)
        
        let home = UINavigationController(rootViewController: ReadingHomeViewController())
        let bookshelf = UINavigationController(rootViewController: BookshelfViewController())
        let like = UINavigationController(rootViewController: LikeViewController())
        let mypage = UINavigationController(rootViewController: MyPageViewController(viewModel: myPageViewModel))
        
        home.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        bookshelf.tabBarItem = UITabBarItem(title: "책장", image: UIImage(systemName: "books.vertical"), selectedImage: UIImage(systemName: "books.vertical.fill"))
        
        like.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        mypage.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [home, bookshelf, like, mypage]
    }
    
    // 홈 화면 한 번 더 클릭해서 스크롤 올리기
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        
        if selectedIndex == lastSelectedIndex {
            if let nav = viewController as? UINavigationController,
               let homeVC = nav.viewControllers.first as? ReadingHomeViewController {
                homeVC.scrollToTop()
            }
            
            if let nav = viewController as? UINavigationController,
               let vc = nav.viewControllers.first as? BookshelfViewController {
                vc.scrollToTop()
            }
            
            if let nav = viewController as? UINavigationController,
               let vc = nav.viewControllers.first as? LikeViewController {
                vc.scrollToTop()
            }
            
        }
        
        lastSelectedIndex = selectedIndex
    }
}
