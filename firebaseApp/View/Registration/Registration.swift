//
//  Registration.swift
//  firebaseApp
//
//  Created by fedot on 05.12.2021.
//

import UIKit
import SnapKit
import Firebase

class Registraion: UIViewController {
    var textFieldSetting    = TextFieldSetting()
    let segmentItems        = ["Телефон","Эл. адрес"]
    var segmentControl      = UISegmentedControl()
    let labelTitle          = UILabel()
    //SignUpEmail
    let textFieldName       = UITextField()
    let textFieldEmail      = UITextField()
    let textFieldPassword   = UITextField()
    let buttonEmail         = UIButton()
    //SignUpPhone
    let textFieldPhone      = UITextField()
    let buttonPhone    = UIButton()
    let textFieldSms        = UITextField()
    
    private let topLayoutGuideBox = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentSetting()
        settingView()
        constraintsSetting()
        
        settingLabel()
        settingTextFields()
        settingButtons()
        
        textFieldEmail.delegate = self
        textFieldPhone.delegate = self
        
        textFieldSetting.hiden(textFieldEmail, bool: true)
        textFieldSetting.hiden(textFieldSms, bool: true)
        buttonEmail.isHidden = true
        
    }

}

extension Registraion {

    private func settingView() {
        view.backgroundColor = .white
        topLayoutGuideBox.backgroundColor = .white
        
        view.addSubview(topLayoutGuideBox)
        topLayoutGuideBox.addSubview(segmentControl)
        topLayoutGuideBox.addSubview(labelTitle)
        topLayoutGuideBox.addSubview(textFieldEmail)
        topLayoutGuideBox.addSubview(textFieldPhone)
        topLayoutGuideBox.addSubview(textFieldSms)
        topLayoutGuideBox.addSubview(buttonEmail)
        topLayoutGuideBox.addSubview(buttonPhone)
    }
    
    private func settingLabel() {
        labelTitle.text = "Введите телефон или электронный адрес"
        labelTitle.numberOfLines = 2
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont(name: "Arial", size: 24)
    }
    
    private func settingTextFields() {
        textFieldSetting.defaultSetting(textFieldEmail, placeholder: "email")
        textFieldSetting.defaultSetting(textFieldPhone, placeholder: "phone number")
        textFieldSetting.defaultSetting(textFieldSms, placeholder: "sms code")
        
        textFieldPhone.text = "+7"
        textFieldPhone.keyboardType = .phonePad
        textFieldSms.keyboardType = .numberPad

    }
    
    private func settingButtons() {
        buttonPhone.configuration = .tinted()
        buttonPhone.setTitle("Получить код", for: .normal)
        buttonPhone.addTarget(self, action: #selector(phoneNextAction), for: .touchUpInside)
        
        buttonEmail.configuration = .tinted()
        buttonEmail.setTitle("Далее", for: .normal)
        buttonEmail.addTarget(self, action: #selector(emailNextAction), for: .touchUpInside)
    }
    
    private func segmentSetting() {
        segmentControl = UISegmentedControl(items: segmentItems)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
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
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(labelTitle).inset(100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
        textFieldEmail.snp.makeConstraints { make in
            make.top.equalTo(segmentControl).inset(60)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        textFieldPhone.snp.makeConstraints { make in
            make.top.equalTo(segmentControl).inset(60)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        textFieldSms.snp.makeConstraints { make in
            make.top.equalTo(segmentControl).inset(60)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        buttonEmail.snp.makeConstraints { make in
            make.top.equalTo(textFieldEmail).inset(40)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        buttonPhone.snp.makeConstraints { make in
            make.top.equalTo(textFieldPhone).inset(40)
            make.width.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Registraion {
    @objc func segmentAction(target: UISegmentedControl) {
        switch target.selectedSegmentIndex {
        case 0:
            textFieldSetting.hiden(textFieldEmail, bool: true)
            textFieldSetting.hiden(textFieldPhone, bool: false)
            textFieldSetting.hiden(textFieldSms, bool: true)
            buttonEmail.isHidden = true
            buttonPhone.isHidden = false
        case 1:
            textFieldSetting.hiden(textFieldEmail, bool: false)
            textFieldSetting.hiden(textFieldPhone, bool: true)
            textFieldSetting.hiden(textFieldSms, bool: true)
            buttonEmail.isHidden = false
            buttonPhone.isHidden = true
        default: break
        }
    }
    
    func signUpSmsVerification() {
        let number = "\(textFieldPhone.text!)"
        AuthManager.shared.authPhone(phoneNumber: number) { success in
            guard success else { return }
        }
    }
    
    func signUpSms() {
        let code = self.textFieldSms.text!
    AuthManager.shared.verifyCode(smsCode: code) {  [weak self] success in
        guard let self = self  else { return }
        guard success else { return }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
       }
    }
    
    
    
    //MARK: Registration email
    @objc func phoneNextAction() {
        let buttonText = buttonPhone.titleLabel?.text
        buttonPhone.setTitle("Далее", for: .normal)
        textFieldPhone.isHidden = true
        textFieldSms.isHidden = false
        signUpSmsVerification()
        
        if buttonText == "Далее" {
            signUpSms()
        }
    }
    
    @objc func emailNextAction() {
        let buttonText = buttonEmail.titleLabel?.text
        print("asd")
        buttonEmail.setTitle("Далее", for: .normal)
        
        if buttonText == "Далее" {
            print("button3")
        }
    }
    
    @objc func signUpEmail() {
        let name = textFieldName.text!
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        
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
