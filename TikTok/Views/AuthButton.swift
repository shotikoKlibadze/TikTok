//
//  AuthButton.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 25.05.22.
//

import UIKit

class AuthButton: UIButton {

    enum ButtonType {
        case signIn
        case signUp
        case plane
        
        var tittle : String {
            switch self {
            case .signIn: return "Sign In"
            case .signUp: return "Sign Up"
            case .plane: return "-"
            }
        }
    }
    
    private let type : ButtonType
    
    init(type: ButtonType, tittle: String?) {
        self.type = type
        super.init(frame: .zero)
        if let tittle = tittle {
            setTitle(tittle, for: .normal)
        }
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        if type != .plane {
            setTitle(type.tittle, for: .normal)
        }
        
        setTitleColor(.white, for: .normal)
        switch type {
        case .signIn:
            backgroundColor = .systemBlue
        case .signUp:
            backgroundColor = .systemGreen
        case .plane:
            setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
}
