//
//  LoginController.swift
//  OSChina
//
//  Created by JKY-jiang on 2017/6/27.
//  Copyright © 2017年 JKY-jiang. All rights reserved.
//

import UIKit

class LoginController: BaseViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var signingUpOulet: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        setUI()
        
        let loginViewModel = SigninViewModel(
            input: (
                username: usernameOutlet.rx.text.orEmpty.asObservable(),
                password: passwordOutlet.rx.text.orEmpty.asObservable(),
                signinTaps: signupOutlet.rx.tap.asObservable()
            ),
            dependency: (
                API: SigninDefaultAPI.sharedAPI,
                validationService: AuthorValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
            )
        )
        
        loginViewModel.signinEnabled
            .subscribe(onNext: { [weak self] valid in
                self?.signupOutlet.isEnabled = valid
                self?.signupOutlet.alpha = valid ? 1.0 : 0.5
            
            })
            .disposed(by: disposeBag)
        
        loginViewModel.validatedUsername
            .bind(to: usernameValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)
        
        loginViewModel.validatedPassword
            .bind(to: passwordValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)
        
        loginViewModel.signingIn
            .bind(to: signingUpOulet.rx.isAnimating)
            .disposed(by: disposeBag)
        
        loginViewModel.signedIn
            .subscribe(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
            .disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    
    func setUI(){
        let margin : CGFloat = 30
        let width = screenW - margin * 2
        let height : CGFloat = 30;
        for i in 0...1 {

            let textFiled = UITextField(frame: CGRect(x: margin, y: 100 + margin + CGFloat(i) * height + CGFloat(i) * margin, width: width, height: height))
            
            textFiled.layer.borderColor = UIColor.lightGray.cgColor
            textFiled.layer.borderWidth = 1
            textFiled.layer.cornerRadius = 3
            textFiled.layer.masksToBounds = true
            
            let tipLabel = UILabel(frame: CGRect(x: margin, y: textFiled.bottom, width: width, height: height))
            
            switch i {
            case 0:
                textFiled.placeholder = "  UserName"
                tipLabel.text = "userName Validation"
                usernameOutlet = textFiled
                usernameValidationOutlet = tipLabel
                break
            case 1:
                textFiled.placeholder = "  Password"
                tipLabel.text = "password Validation"
                passwordOutlet = textFiled
                passwordValidationOutlet = tipLabel
                break
            default:
                break
            }
            
            self.view.addSubview(textFiled)
            self.view.addSubview(tipLabel)
        }
        
        let signBtn = UIButton(frame: CGRect(x: 30, y: passwordValidationOutlet.bottom + 50, width: screenW - 60, height: 44))
        signBtn.setTitle("Login", for: UIControlState.normal)
        signBtn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        signupOutlet = signBtn
        self.view.addSubview(signBtn)
        
        let signingUpOulet = UIActivityIndicatorView(frame: CGRect(x: signBtn.left, y: 12, width: 20, height: 20))
        signBtn.addSubview(signingUpOulet)
        
        self.signingUpOulet = signingUpOulet;
        
    }

}
