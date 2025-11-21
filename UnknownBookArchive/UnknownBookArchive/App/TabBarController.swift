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
        setupTabs()
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
