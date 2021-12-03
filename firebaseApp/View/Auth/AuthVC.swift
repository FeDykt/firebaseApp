//
//  AuthVC.swift
//  firebaseApp
//
//  Created by fedot on 02.12.2021.
//

import Foundation
import UIKit
import SnapKit
import Firebase

class AuthVC: UIViewController {
    var stackViewVertical = UIStackView()
    var labelLogin        = UILabel()
    var textFieldLogin    = UITextField()
    var textFieldEmail    = UITextField()
    var textFieldPassword = UITextField()
    var buttonUpload      = UIButton()
    
    
    var signUp = true {
        willSet {
            if newValue {
                labelLogin.text = "Регистрация"
                textFieldLogin.isHidden = false
                buttonUpload.setTitle("Зарегистрироваться", for: .normal)
            } else {
                labelLogin.text = "Авторизация"
                textFieldLogin.isHidden = true
                buttonUpload.setTitle("Войти", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingViews()
        settingConstrains()
        navBarButtons()
   
        view.backgroundColor = .white

        textFieldLogin.delegate = self
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self

        
    }
    
    //MARK: objc metods
    
    @objc func uploadButtonAction() {
        signUp = !signUp
    }
    @objc func exitButton() {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print(error)
                }
    }
    
    func navBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitButton))
    }
    
    
    
    func settingViews() {
        //MARK: StackView Setting
        stackViewVertical.axis = .vertical
        stackViewVertical.spacing = 10
        stackViewVertical.alignment = .center
        
        //MARK: Label Setting
        labelLogin.text = "Registration"
        
        //MARK: TextFields Setting
        textFieldEmail.borderStyle = .roundedRect
        textFieldLogin.borderStyle = .roundedRect
        textFieldPassword.borderStyle = .roundedRect
        
        //MARK: return key type
        textFieldLogin.returnKeyType = .next
        textFieldEmail.returnKeyType = .next
        textFieldPassword.returnKeyType = .done
        
        textFieldPassword.textContentType = .password
        
        textFieldEmail.placeholder = "email"
        textFieldLogin.placeholder = "login"
        textFieldPassword.placeholder = "password"
        
        //MARK: Button setting
        buttonUpload.configuration = .tinted()
        buttonUpload.setTitle("Зарегистрироваться", for: .normal)
        buttonUpload.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
        
        //MARK: ADD subviews
        view.addSubview(stackViewVertical)
        stackViewVertical.addArrangedSubview(labelLogin)
        stackViewVertical.addArrangedSubview(textFieldLogin)
        stackViewVertical.addArrangedSubview(textFieldEmail)
        stackViewVertical.addArrangedSubview(textFieldPassword)
        stackViewVertical.addArrangedSubview(buttonUpload)
    }
    
    func settingConstrains() {
        stackViewVertical.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        textFieldLogin.snp.makeConstraints { make in
            make.width.equalToSuperview()
            
        }
        textFieldEmail.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        textFieldPassword.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
}

extension AuthVC: UITextFieldDelegate {
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = textFieldLogin.text!
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!

        if textField == textFieldLogin {
            textField.resignFirstResponder()
            textFieldEmail.becomeFirstResponder()
        }  else if textField == textFieldEmail {
            textField.resignFirstResponder()
            textFieldPassword.becomeFirstResponder()
        }

        if (signUp) {
            if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error == nil {
                        if let result = result {
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name" : name, "email": email])
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        print("error: \(String(describing: error))")
                    }
                }
        } else {
                showAlert()
            }
        } else {
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }  else {
                        print(error)
                    }
                }
            } else {
                showAlert()
            }
        }
        return true
    }
}
