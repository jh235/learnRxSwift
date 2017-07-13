//
//  BaseNavigationController.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/22.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = appColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //在这个地方判断如果当前Push进来是第二个控制器的话,把他的返回按钮的title设置成第一个控制器的title
        
        //如果childViewControllers.count == 1的话,执行到这个地方,就代表要往里面push第2个控制器
        if childViewControllers.count>0 {
            
            var titleName = "返回"
            
            //现在判断的时候并没有真正的把ctrl push进去
            if childViewControllers.count == 1 {
                //把他的返回按钮的title设置成第一个控制器的title
                
                //1.拿到第1个控制器 //2.设置
                 titleName = childViewControllers.first!.title!
                
            }
            
            //当push出来的时候,隐藏底部的bar
            viewController.hidesBottomBarWhenPushed = true
            //设置返回键盘
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.item("navigationbar_back_withtext", title: titleName, target: self, action: #selector(back))
            
        }
        
        //在这句代码执行之后,才会真正的更新childViewControllers.count
        super.pushViewController(viewController, animated: animated)
    }
    
    func back() {
        self .popViewController(animated: true)
    }
    
}
