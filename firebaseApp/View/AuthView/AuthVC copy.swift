//
//  AuthTest.swift
//  firebaseApp
//
//  Created by fedot on 03.12.2021.
//

import Foundation
import UIKit
import SnapKit
import Firebase
import FirebaseStorage
import SwiftUI

class AuthVCcopy: UIViewController {
    let stackViewVertical = UIStackView()
    let logoImage         = UIImageView()
    let textFieldEmail    = UITextField()
    let textFieldPassword = UITextField()
    let buttonTextFieldRightView  = UIButton(type: .custom)
    var textFieldPasswordHide = true {
       willSet {
           if newValue {
               textFieldPassword.isSecureTextEntry = true
        } else {
                textFieldPassword.isSecureTextEntry = false
        }
       }
    }
    let buttonForgotPass = UIButton()
    let buttonSignIn     = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        settingViews()
        settingConstrains()
   
        view.backgroundColor = .white

        textFieldEmail.delegate = self
        textFieldPassword.delegate = self   
    }

    func settingViews() {
        //MARK: StackView Setting
        stackViewVertical.axis = .vertical
        stackViewVertical.spacing = 10
        stackViewVertical.alignment = .lastBaseline
        
        //MARK: Logotype
        logoImage.image = UIImage(named: "logotype")

        //MARK: TextFields Setting
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.autocorrectionType = .no
        textFieldEmail.backgroundColor = .systemGray6
        
        textFieldPassword.backgroundColor = .systemGray6
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.autocorrectionType = .no
        textFieldPassword.isSecureTextEntry = true
        
        textFieldEmail.placeholder = "Введите электронную почту"
        textFieldPassword.placeholder = "Введите пароль"
        
        //MARK: return key type
        textFieldEmail.returnKeyType = .next
        textFieldPassword.returnKeyType = .done
        
        
        //MARK: hide/show password textfield
        buttonTextFieldRightView.setImage(UIImage(systemName: "eye"), for: .normal)
        buttonTextFieldRightView.tintColor = .black
        buttonTextFieldRightView.addTarget(self, action: #selector(viewPassword), for: .touchUpInside)
        buttonTextFieldRightView.frame = CGRect(x:-10, y:0, width:30, height:30)
       
        textFieldPassword.rightViewMode = .always
        textFieldPassword.rightView = buttonTextFieldRightView
        
        //MARK: forgotPass / signUp button
        buttonForgotPass.setTitle("Забыли пароль?", for: .normal)
        buttonForgotPass.configuration = .plain()
        
        buttonSignIn.configuration = .filled()
        buttonSignIn.setTitle("Войти", for: .normal)
        buttonSignIn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
                
        //MARK: ADD subviews
        view.addSubview(stackViewVertical)
        stackViewVertical.addArrangedSubview(logoImage)
        stackViewVertical.addArrangedSubview(textFieldEmail)
        stackViewVertical.addArrangedSubview(textFieldPassword)
        stackViewVertical.addArrangedSubview(buttonForgotPass)
        stackViewVertical.addArrangedSubview(buttonSignIn)
    }
    
    func settingConstrains() {
        stackViewVertical.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        logoImage.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        textFieldEmail.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        textFieldPassword.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        buttonSignIn.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        buttonForgotPass.snp.makeConstraints { make in
            make.trailing.equalTo(0).inset(-10)
        }
    }
    
}

//MARK: objc metods
extension AuthVCcopy {
    
    @objc func viewPassword() {
        textFieldPasswordHide = !textFieldPasswordHide
        
        if textFieldPassword.isSecureTextEntry == true {
            buttonTextFieldRightView.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            buttonTextFieldRightView.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @objc func signIn() {
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
}

extension AuthVCcopy: UITextFieldDelegate {
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldPassword.resignFirstResponder()
        }

        return true
    }
}

