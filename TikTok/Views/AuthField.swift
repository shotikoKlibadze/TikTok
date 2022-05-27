//
//  AuthField.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 25.05.22.
//

import UIKit

class AuthField: UITextField {
    
    enum Fieldtype {
        case email
        case password
        case username
        
        var tittle : String {
            switch self {
            case .email:
                return "Email Adress"
            case .password:
                return "Password"
            case .username:
                return "Username"
            }
        }
    }
    
    private let type : Fieldtype

    init(type: Fieldtype) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        autocapitalizationType = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.tittle
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        } else if type == .password {
            isSecureTextEntry = true
        }
    }
    
}
