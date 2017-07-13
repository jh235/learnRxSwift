//
//  NewsModel.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/22.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import Alamofire
import Moya


struct NewsModel : HandyJSON {
    
    var author: NewsAuthor?
    var body: String?
    var comment_count: Int?
    var id: Int?
    var pub_date: String?
    var title: String?
    var type: Int?
    var url: String?
}

struct NewsAuthor : HandyJSON {
    
    var id: Int?
    var name: String?
    var portrait: String?
    var body : String?
}

struct NewsList : HandyJSON {
    
    var code : String?
    var obj_list : [NewsModel]?
}

struct NewsViewModel {
    
    var disposeBag = DisposeBag()
    var provider: RxMoyaProvider<APIService>
    var backgroundScheduler: OperationQueueScheduler!
    var pageIndex = 0
    
    init() {
        let operationQueue = OperationQueue()
        backgroundScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        provider = RxMoyaProvider<APIService>()
    }
    

    func newsArr() -> Observable<[NewsModel]> {
        return news().flatMap({ newRoot -> Observable<[NewsModel]> in
            Variable(newRoot.obj_list!).asObservable()
        })
    }
    
    func banners() -> Observable<[BannerItem]> {
        return banner().flatMap({ (newRoot) -> Observable<[BannerItem]> in
            Variable(newRoot.result!.items!).asObservable()
        })
    }

    
    func news() -> Observable<NewsList> {
        
        return Observable.create({ observer -> Disposable in
            self.provider.request(APIService.newsList(para: ["pageIndex": 0]))
                .mapModel(NewsList.self)
                .subscribe({ list in
                    observer.on(list)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
    
    func banner() -> Observable<BannerRootClass>{
        
        return Observable.create({ observer -> Disposable in
            self.provider.request(APIService.newBanner)
                .mapModel(BannerRootClass.self)
                .subscribe({ list in
                    observer.on(list)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }

}



