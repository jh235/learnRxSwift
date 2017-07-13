//
//  BannerModel.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/23.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import Foundation
import HandyJSON

struct BannerItem :HandyJSON {
    
    var detail : String?
    var href : String?
    var id : Int = 0
    var img : String?
    var name : String?
    var pubDate : String?
    var type : Int = 0

}

struct BannerRootClass :HandyJSON {
    
    var code: Int?
    var message: String?
    var result: ListModel?
    var time: String?
}

struct ListModel : HandyJSON {
    
    var items: [BannerItem]?
    var nextPageToken: String?
    var prevPageToken: String?
    var requestCount : Int = 0
    var responseCount : Int = 0
    var totalResults : Int = 0

}
