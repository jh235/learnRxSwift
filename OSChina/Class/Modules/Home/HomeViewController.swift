//
//  HomeViewController.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/22.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import AutoCycleAdview
import MJRefresh

class HomeViewController: BaseViewController {

    let viewModel = NewsViewModel()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, NewsModel>>()
    let dataArr = Variable([SectionModel<String, NewsModel>]())
    
    var bannerItems: [BannerItem]? = []{
        didSet {
            if let banners = bannerItems {
                
                let imagUrls = banners.flatMap({ $0.img })
                let titles = banners.flatMap({ $0.name })
                headerView.imagUrls = imagUrls
                headerView.titles = titles
                headerView.pageControlAlignment = .right
                headerView.callback = { [weak self] index in
                    let dest = WebViewController()
                    dest.title = titles[index]
                    dest.urlStr = banners[index].href
                    self?.navigationController?.pushViewController(dest, animated: true)
                }
            }
        }
    }

    var statusBackView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.frame = CGRect.init(x: 0, y: 0, width: screenW, height: 20)
        $0.isHidden = true
    }
    
    var headerView = AutoCycleAdview().then {
        $0.backgroundColor = UIColor.white
        $0.frame = CGRect.init(x: 0, y: 10, width: screenW, height: 180)
    }
    
    var tableView = UITableView().then {
        $0.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "综合"
        
        setTableView()
        
    }
    
    func setTableView() {
        
        self.view.addSubview(tableView)
        
        viewModel.banner()
            .subscribe(onNext: { (banner) in
                self.tableView.tableHeaderView = self.headerView;
                self.bannerItems = banner.result?.items
            })
            .disposed(by: disposeBag)
        
        viewModel.news()
            .subscribe(onNext: { (model) in
                self.dataArr.value = [SectionModel(model: model.code!, items: model.obj_list!)]
            })
            .addDisposableTo(disposeBag)
        
        tableView.mj_footer = MJRefreshAutoStateFooter(refreshingBlock: {
            if self.tableView.mj_footer.isRefreshing(){
                self.tableView.mj_footer.endRefreshing()
                return
            }
        })
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        
        let dataSource = self.dataSource
        
        dataSource.configureCell = { _, tableView, _, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.textLabel?.text = element.body
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        dataArr
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(NewsModel.self)
            .subscribe(onNext: { item in
                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
                
                let dest = WebViewController()
                dest.title = item.title
                dest.urlStr = item.url
                self.navigationController?.pushViewController(dest, animated: true)
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10;
//    }
}

extension UITableViewCell {
    
    //    static let reuseid = String(describing: self)
    static let reuseid = String(describing: UITableViewCell.self)
    
}
