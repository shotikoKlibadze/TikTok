//
//  SignUpViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {

    public var completion : (() -> Void)?
    
    private let logoImageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.image = UIImage(named: "logo")
        imgv.layer.cornerRadius = 10
        imgv.layer.masksToBounds = true
        return imgv
    }()
    private let userNameField = AuthField(type: .username)
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    
    private let signUpButton = AuthButton(type: .signUp, tittle: nil)
    private let termsButton = AuthButton(type: .plane, tittle: "Terms of Service")
    
    
    // MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Account"
        addSubviews()
        configureFields()
        configureButtons()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameField.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize : CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize) / 2, y: view.safeAreaInsets.top + 5 , width: imageSize, height: imageSize)
        
        
        userNameField.frame = CGRect(x: 20, y: logoImageView.bottom + 15 , width: view.width-40, height: 55)
        emailField.frame = CGRect(x: 20, y: userNameField.bottom + 20 , width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 15 , width: view.width-40, height: 55)
        
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom+20, width: view.width-40, height: 55)
        termsButton.frame = CGRect(x: 20, y: signUpButton.bottom+40, width: view.width-40, height: 55)
       
    }
    private func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        userNameField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyBoardDone))
        ]

        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
        userNameField.inputAccessoryView = toolBar
    }
    
    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(userNameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
        
    }
    
    private func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
    }
    
    @objc func didTapSignUp() {
        didTapKeyBoardDone()
        guard let username = userNameField.text,
              let password = passwordField.text,
              let email = emailField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            let alert = UIAlertController(title: "Oops", message: "Please fill in all the fields, password must be at least 6 characters long.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        AuthManager.shared.signUp(with: username, email: email, password: password) { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sign Up Failed", message: "Something went wrong, Try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self?.present(alert, animated: true)
                }
            }
        }
        
    }
    
    @objc func didTapTerms() {
        didTapKeyBoardDone()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapForgotPassword() {
        guard let url = URL(string: "https://www.tiktok.com/") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapKeyBoardDone() {
        userNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}

extension SignUpViewController : UITextFieldDelegate {
    
}
