//
//  BaseViewController.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/22.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class BaseViewController: UIViewController {
    
    lazy var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.backgroundColor = UIColor.groupTableViewBackground

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
