//
//  SigninViewModel.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/27.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class SigninViewModel {
    
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    
    // Is signup button enabled
    let signinEnabled: Observable<Bool>
    
    // Has user signed in
    var signedIn: Observable<Bool>
    
    // Is signing process in progress
    let signingIn: Observable<Bool>
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        signinTaps: Observable<Void>
        ),
         dependency: (
        API: SigninAPI,
        validationService: SigninValidationService,
        wireframe: Wireframe
        )
        ) {
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        validatedUsername = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
            }
            .shareReplay(1)
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }
            .shareReplay(1)
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        signedIn = input.signinTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signin(pair.username, password: pair.password)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(false)
                    .trackActivity(signingIn)
            }
            .flatMapLatest { loggedIn -> Observable<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    // propagate original value
                    .map { _ in
                        loggedIn
                }
            }
            .shareReplay(1)
        
        signinEnabled = Observable.combineLatest(
            validatedUsername,
            validatedPassword,
            signingIn.asObservable()
        )   { username, password, signingIn in
            username.isValid &&
                password.isValid &&
                !signingIn
            }
            .distinctUntilChanged()
            .shareReplay(1)
    }

}
