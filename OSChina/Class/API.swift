//
//  API.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/22.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import Foundation
import UIKit
import Moya

enum APIService {
    case newsList(para: [String: Int])
    case newBanner, tweetList, blogList, eventList, eventBanner
    case login(username: String, password: String)
    case findUser(name: String)
    case search(content: String)
}

extension APIService : TargetType{
    /// The target's base `URL`.
    var baseURL: URL {
        // return NSURL(string: "http://www.oschina.net/action/api")! //XML格式
        return URL(string: "http://www.oschina.net/action/apiv2")! // JSON格式
    }
    
    var path: String {
        switch self {
        case let .newsList(para):
            return "/news_list/?\(para.keys.first!)=\(para.values.first!)&pageSize=2"
        case .newBanner:
            return "/banner"
        case .tweetList:
            return "/tweet_list"
        case .blogList:
            return "/blog_list"
        case .eventList:
            return "/event_list"
        case .eventBanner:
            return "/banner"
        case .login:
            return "/login_validate"
        case .findUser:
            return "/find_user"
        case .search:
            return "/search_list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .login(username, password):
            return ["username": username, "pwd": password]
        case .newBanner:
            return ["catalog": 1]
        case .eventBanner:
            return ["catalog": 3]
        case let .findUser(name):
            return ["name": name]
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)! // for test
    }
    
    var multipartBody: [MultipartFormData]? {
        return nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        return .request
    }
    
    var validate: Bool {
        return false
    }

}


