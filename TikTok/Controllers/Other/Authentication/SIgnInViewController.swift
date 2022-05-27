//
//  SIgnInViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 04.05.22.
//

import SafariServices
import UIKit

class SIgnInViewController: UIViewController {
    
    public var completion : (() -> Void)?
    
    private let logoImageView : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.image = UIImage(named: "logo")
        imgv.layer.cornerRadius = 10
        imgv.layer.masksToBounds = true
        return imgv
    }()
    
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    private let signInButton = AuthButton(type: .signIn, tittle: nil)
    private let forgotPasswordButton = AuthButton(type: .plane, tittle: "Forgot Password")
    private let signUpButton = AuthButton(type: .plane, tittle: "New User? Creage Account")
    
    // MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        addSubviews()
        configureFields()
        configureButtons()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize : CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize) / 2, y: view.safeAreaInsets.top + 5 , width: imageSize, height: imageSize)
        
        emailField.frame = CGRect(x: 20, y: logoImageView.bottom + 20 , width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 15 , width: view.width-40, height: 55)
        
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom+20, width: view.width-40, height: 55)
        forgotPasswordButton.frame = CGRect(x: 20, y: signInButton.bottom+40, width: view.width-40, height: 55)
        signUpButton.frame = CGRect(x: 20, y: forgotPasswordButton.bottom+20, width: view.width-40, height: 55)
    }
    
    private func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyBoardDone))
        ]

        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
    }
    
    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(signUpButton)
    }
    
    private func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    @objc func didTapSignIn() {
        didTapKeyBoardDone()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            let alert = UIAlertController(title: "Oops", message: "Please enter valid email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        AuthManager.shared.signIn(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    self?.dismiss(animated: true)
                case .failure(_):
                    let alert = UIAlertController(title: "Sign In Failed", message: "Pleace check your email and password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self?.present(alert, animated: true)
                    self?.passwordField.text = nil
                }
            }
        }
    }
    
    @objc func didTapSignUp() {
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
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
   
    


}

extension SIgnInViewController : UITextFieldDelegate {
    
}
