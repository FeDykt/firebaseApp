//
//  AuthVC.swift
//  firebaseApp
//
//  Created by fedot on 02.12.2021.
//

import Foundation
import UIKit
import SnapKit

class AuthVC: UIViewController {
    var stackViewVertical = UIStackView()
    var labelLogin        = UILabel()
    var textFieldLogin    = UITextField()
    var textFieldPassword = UITextField()
    var buttonUpload      = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(stackViewVertical)
        stackViewVertical.axis = .vertical
        stackViewVertical.distribution = .fillEqually
        stackViewVertical.spacing = 30
        
        stackViewVertical.addSubview(labelLogin)
        stackViewVertical.addSubview(textFieldLogin)
        stackViewVertical.addSubview(textFieldPassword)
        stackViewVertical.addSubview(buttonUpload)
        snpSetting()
        
        labelLogin.text = "Регистрация"
        textFieldLogin.placeholder = "login"
        textFieldLogin.borderStyle = .roundedRect
        textFieldPassword.placeholder = "password"
        textFieldPassword.borderStyle = .roundedRect
        buttonUpload.setTitle("Upload", for: .normal)
        buttonUpload.configuration = .plain()
        buttonUpload.configuration?.cornerStyle = .capsule
        buttonUpload.configuration?.baseBackgroundColor = .red
    }
    
    private func snpSetting() {
        
        stackViewVertical.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(30)
            make.height.equalTo(300)
        }
        
        labelLogin.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        textFieldLogin.snp.makeConstraints { make in
            make.top.equalTo(labelLogin).inset(40)
            make.left.right.equalToSuperview()
        }
        textFieldPassword.snp.makeConstraints { make in
            make.top.equalTo(textFieldLogin).inset(40)
            make.left.right.equalToSuperview()
        }
        buttonUpload.snp.makeConstraints { make in
            make.top.equalTo(textFieldPassword).inset(40)
            make.centerX.equalToSuperview()
        }
    }
    
}
