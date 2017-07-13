//
//  AuthorValidationService.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/26.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import Foundation
import RxSwift

class AuthorValidationService: SignupValidationService , SigninValidationService{
    let signupAPI : SignupAPI
    let signinAPI : SigninAPI
    
    init (API: SignupAPI ,API1 : SigninAPI) {
        self.signupAPI = API
        self.signinAPI = API1
    }
    
    static let sharedValidationService = AuthorValidationService(API: SignupDefaultAPI.sharedAPI, API1: SigninDefaultAPI.sharedAPI)
    
    let minPasswordCount = 5
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.characters.count == 0 {
            return .just(.empty)
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "Username can only contain numbers or digits"))
        }
        
        if username.characters.count < 6 {
           return .just(.failed(message: "Username must be at least \(minPasswordCount) characters"))
        }
        
        let loadingValue = ValidationResult.validating
        
        return signupAPI
            .usernameAvailable(username)
            .map { available in
                if available {
                    return .ok(message: "Username available")
                }
                else {
                    return .failed(message: "Username already taken")
                }
            }
            .startWith(loadingValue)
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        
        let numberOfCharacters = password.characters.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
        
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        
        if repeatedPassword.characters.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }

    }
}

class SignupDefaultAPI: SignupAPI {
    let URLSession: Foundation.URLSession
    
    static let sharedAPI = SignupDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }

    
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        return Observable.just(true)
    }
    
    func signup(_ username: String, password: String) -> Observable<Bool> {
        
//        return Observable.just(true)
        
        let signupResult = arc4random() % 5 == 0 ? false : true
        
        return Observable.just(signupResult)
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}

class SigninDefaultAPI: SigninAPI {
    
    let URLSession: Foundation.URLSession
    
    static let sharedAPI = SigninDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }

    
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        return Observable.just(true)
    }
    
    func signin(_ username: String, password: String) -> Observable<Bool> {
        
//        return Observable.just(true)
        
        let signupResult = arc4random() % 5 == 0 ? false : true
        
        return Observable.just(signupResult)
            .delay(1.0, scheduler: MainScheduler.instance)
        
    }

    
}
