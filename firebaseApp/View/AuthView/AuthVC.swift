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

class AuthVC: UIViewController {
    let stackViewVertical = UIStackView()
    var labelLogin        = UILabel()
    let textFieldLogin    = UITextField()
    let textFieldEmail    = UITextField()
    let textFieldPassword = UITextField()
    let buttonUpload      = UIButton()
    let buttonSwitch      = UIButton()
    static let imagePicker       = UIImageView()
    let imagePickerButton = UIButton()
    
    
    var signUp = true {
        willSet {
            if newValue {
            labelLogin.text = "Регистрация"
            textFieldLogin.isHidden = false
            buttonUpload.setTitle("Зарегистрироваться", for: .normal)
            buttonUpload.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
            buttonSwitch.setTitle("Есть профиль?", for: .normal)
            buttonSwitch.addTarget(self, action: #selector(switchAction), for: .touchUpInside)
        } else {
            labelLogin.text = "Авторизация"
            textFieldLogin.isHidden = true
            buttonUpload.setTitle("Войти", for: .normal)
            buttonUpload.addTarget(self, action: #selector(signIn), for: .touchUpInside)
            buttonSwitch.setTitle("Нету профиля?", for: .normal)
            buttonSwitch.addTarget(self, action: #selector(switchAction), for: .touchUpInside)
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
        textFieldLogin.borderStyle = .roundedRect
        textFieldLogin.autocorrectionType = .no
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.autocorrectionType = .no
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.autocorrectionType = .no
        textFieldPassword.isSecureTextEntry = true
        
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
        buttonSwitch.configuration = .tinted()
        buttonSwitch.setTitle("Есть профиль?", for: .normal)
        buttonSwitch.addTarget(self, action: #selector(switchAction), for: .touchUpInside)
        
        //MARK: imagePicker
        imagePickerButton.setTitle("check photo", for: .normal)
        imagePickerButton.configuration = .tinted()
        imagePickerButton.addTarget(self, action: #selector(imagePickerAction), for: .touchUpInside)
        
        AuthVC.imagePicker.image = UIImage(systemName: "person")
    
                
        //MARK: ADD subviews
        view.addSubview(stackViewVertical)
        stackViewVertical.addArrangedSubview(buttonSwitch)
        stackViewVertical.addArrangedSubview(AuthVC.imagePicker)
        stackViewVertical.addArrangedSubview(imagePickerButton)
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
        AuthVC.imagePicker.snp.makeConstraints { make in
            make.width.height.equalTo(80)
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

//MARK: objc metods
extension AuthVC {
    
    @objc func switchAction() {
        signUp = !signUp
    }
    
    func uploadImage(currentUserId: String , photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void ) {
        let storageRef = Storage.storage().reference().child("avatars").child(currentUserId)
        guard let imageData = AuthVC.imagePicker.image?.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metaData) { metadata, error in
            guard let _ = metadata else { completion(.failure(error!)); return }
            storageRef.downloadURL { url, error in
                guard let url = url else { completion(.failure(error!)); return }
                completion(.success(url))
            }
        }
        
    }
    
    @objc func signUpAction() {
        let name = textFieldLogin.text!
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        
        DispatchQueue.main.async {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error == nil {
                    if let result = result {
                        self.uploadImage(currentUserId: result.user.uid, photo: AuthVC.imagePicker.image!) { AvatarResult in
                            switch AvatarResult {
                            case .success(let url):
                                let userAvatar = url.absoluteString
                                
                                let ref = Database.database().reference().child("users")
                                ref.child(result.user.uid).updateChildValues(["name" : name, "email": email, "avatar": userAvatar])
                                self.dismiss(animated: true, completion: nil)
                            case .failure(let error):
                                print("error avatar create \(error)")
                            }
                        }
                        
                        
                    }
                } else {
                    print("error: \(String(describing: error))")
                }
            }
        }
        
    }
    
    @objc func signIn() {
        let email = textFieldEmail.text!
        let password = textFieldPassword.text!
        
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    @objc func exitButton() {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print(error)
                }
    }
    
    @objc func imagePickerAction() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension AuthVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        AuthVC.imagePicker.image = image
    }
}

extension AuthVC: UITextFieldDelegate {
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == textFieldLogin {
            textField.resignFirstResponder()
            textFieldEmail.becomeFirstResponder()
        }  else if textField == textFieldEmail {
            textField.resignFirstResponder()
            textFieldPassword.becomeFirstResponder()
        }

        return true
    }
}

