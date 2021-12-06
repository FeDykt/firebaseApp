//
//  Registration.swift
//  firebaseApp
//
//  Created by fedot on 05.12.2021.
//

import UIKit
import SnapKit

class Registraion: UIViewController {
    var textFieldSetting    = TextFieldSetting()
    let labelTitle          = UILabel()
    let textFieldEmail      = UITextField()
    let textFieldPhone      = UITextField()
    let buttonFieldPhone    = UIButton(type: .custom)
    let textFieldSms        = UITextField()
    let buttonFieldSms      = UIButton(type: .custom)
    
    private let topLayoutGuideBox = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        settingLabel()
        settingTextFields()
        constraintsSetting()
        
        view.backgroundColor = .white
        topLayoutGuideBox.backgroundColor = .white
        textFieldEmail.delegate = self
        textFieldPhone.delegate = self
        
        textFieldEmail.isHidden = true
        
        
        buttonFieldPhone.addTarget(self, action: #selector(phoneAction), for: .touchUpInside)
        buttonFieldPhone.setImage(UIImage(systemName: "eye"), for: .normal)
        buttonFieldPhone.tintColor = .black
        buttonFieldPhone.frame = CGRect(x:-10, y:0, width:30, height:30)
        textFieldPhone.rightViewMode = .always
        textFieldPhone.rightView = buttonFieldPhone
        
        textFieldSms.rightViewMode = .always
        textFieldSms.rightView = buttonFieldSms
        buttonFieldSms.addTarget(self, action: #selector(smsAction), for: .touchUpInside)
        buttonFieldSms.setImage(UIImage(systemName: "eye"), for: .normal)
        buttonFieldSms.tintColor = .black
        buttonFieldSms.frame = CGRect(x:-10, y:0, width:30, height:30)
    }
    
}

extension Registraion {
    private func settingView() {
        view.addSubview(topLayoutGuideBox)
        topLayoutGuideBox.addSubview(labelTitle)
        topLayoutGuideBox.addSubview(textFieldEmail)
        topLayoutGuideBox.addSubview(textFieldPhone)
        topLayoutGuideBox.addSubview(textFieldSms)
    }
    
    private func settingLabel() {
        labelTitle.text = "Введите номер телефона или электронный адрес"
        labelTitle.font = UIFont(name: "Arial", size: 24)
    }
    
    private func settingTextFields() {
        textFieldSetting.defaultSetting(textFieldEmail, placeholder: "email")
        textFieldSetting.defaultSetting(textFieldPhone, placeholder: "phone number")
        textFieldSetting.defaultSetting(textFieldSms, placeholder: "sms code")
  
        textFieldSms.isHidden = true
    }
    
    
    private  func constraintsSetting() {
        topLayoutGuideBox.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        labelTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        textFieldEmail.snp.makeConstraints { make in
            make.top.equalTo(labelTitle).inset(80)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        textFieldPhone.snp.makeConstraints { make in
            make.top.equalTo(textFieldEmail).inset(80)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        textFieldSms.snp.makeConstraints { make in
            make.top.equalTo(textFieldPhone).inset(80)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Registraion {
    @objc func phoneAction() {
        let number = "\(textFieldPhone.text!)"
        AuthManager.shared.authPhone(phoneNumber: number) { [weak self] success in
            guard let self = self  else { return }
            guard success else { return }
            print("successs: \(success)")
            self.dismiss(animated: true, completion: nil)
        }
        self.textFieldSms.isHidden = false
    }
    
    @objc func smsAction() {
        let code = self.textFieldSms.text!
        print("code: \(code)")
    AuthManager.shared.verifyCode(smsCode: code) {  [weak self] success in
        guard let self = self  else { return }
        guard success else { return }
        DispatchQueue.main.async {
            let vc = TableViewController()
            self.present(vc, animated: true)
        }
       }
    }
}

extension Registraion: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == textFieldSms {
            print("phone")
        } else if textField == textFieldSms {
            print("sms")
        }

        
        return true
    }
}
