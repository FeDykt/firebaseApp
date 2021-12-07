//
//  TextField.swift
//  firebaseApp
//
//  Created by fedot on 06.12.2021.
//

import UIKit

struct TextFieldSetting {
    mutating func defaultSetting(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
   }
    mutating func hiden(_ textField: UITextField, bool: Bool) {
        textField.isHidden = bool
    }
}
