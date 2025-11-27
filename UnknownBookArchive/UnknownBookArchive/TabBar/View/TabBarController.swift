//
//  TabBarController.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/21/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar(), forKey: "tabBar")
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        

        // 색상 설정
        let normal = appearance.stackedLayoutAppearance.normal
        normal.titleTextAttributes = [.foregroundColor: UIColor.normalColor]
        
        let selected = appearance.stackedLayoutAppearance.selected
        selected.titleTextAttributes = [.foregroundColor: UIColor.primaryColor]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = .primaryColor
        tabBar.unselectedItemTintColor = .normalColor
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupTabs() {
        let home = UINavigationController(rootViewController: ReadingHomeViewController())
        let bookshelf = UINavigationController(rootViewController: BookshelfViewController())
        let like = UINavigationController(rootViewController: LikeViewController())
        let mypage = UINavigationController(rootViewController: MyPageViewController())
        
        home.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        bookshelf.tabBarItem = UITabBarItem(title: "책장", image: UIImage(systemName: "books.vertical"), selectedImage: UIImage(systemName: "books.vertical.fill"))
        
        like.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        mypage.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [home, bookshelf, like, mypage]
    }
    
    
}
