//
//  SigninProtocol.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/26.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import RxSwift

enum SigninState {
    case signedIn(signedIn: Bool)
}

protocol SigninAPI {
    func usernameAvailable(_ username: String) -> Observable<Bool>
    func signin(_ username: String, password: String) -> Observable<Bool>
}

protocol SigninValidationService {
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
}
