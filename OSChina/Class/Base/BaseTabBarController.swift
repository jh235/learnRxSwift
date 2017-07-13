//
//  BaseTabBarController.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/22.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = appColor
        self.selectedIndex = 0
        
        let controller1 = HomeViewController()
        let controller2 = LoginController()
        controller2.title = "发现"
        let controller3 = SginupController()
        controller3.title = "我"
        
        let controllers: [(String, UIImage, UIImage, UIViewController)] = [
            (title: "综合", imge: UIImage(named: "tabbar-news")!, simage: UIImage(named: "tabbar-news-selected")!, controller1),
            (title: "发现", imge: UIImage(named: "tabbar-discover")!, simage: UIImage(named: "tabbar-discover-selected")!, controller2),
            (title: "我", imge: UIImage(named: "tabbar-me")!, simage: UIImage(named: "tabbar-me-selected")!, controller3),
            ]
        controllers.forEach {
            self.append($3, title: $0, image: $1, selectedImage: $2)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func append(_ controller: UIViewController, title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) {
        controller.tabBarItem.title = title
        controller.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        controller.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        addChildViewController(BaseNavigationController(rootViewController: controller))
    }

}
