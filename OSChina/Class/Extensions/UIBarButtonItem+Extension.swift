//
//  UIBarButtonItem + Extension.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/22.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    static func item(_ imageName: String = "", title: String = "", target: AnyObject?, action: Selector) -> UIBarButtonItem {
        //初始化一个button
        let button = UIButton()
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        //判断是否有title
        if title.characters.count>0 {
            //设置文字以及字体颜色,以及字体大小
            button.setTitle(title, for: UIControlState())
            //            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            //默认的颜色
            button.setTitleColor(UIColor.black, for: UIControlState())
            //            button.setTitleColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), for: UIControlState())
            //高亮的颜色
            //            button.setTitleColor(UIColor.orange, for: UIControlState.highlighted)
        }
        
        if imageName.characters.count>0 {
            
            //设置button的不同状态的图片
            button.setImage(UIImage(named: imageName), for: UIControlState())
            //高亮的图片
            button.setImage(UIImage(named: "\(imageName)_highlighted"), for: UIControlState.highlighted)
        }
        //调整大小
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }

}
