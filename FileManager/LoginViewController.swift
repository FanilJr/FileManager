//
//  LoginViewController.swift
//  FileManager
//
//  Created by Fanil_Jr on 24.10.2022.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Login or email"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.tintColor = UIColor(named: "#4885CC")
        textField.keyboardType = .emailAddress
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        textField.tintColor = UIColor(named: "#4885CC")
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return textField
    }()
    
    let logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        
    }
    
    private func layout() {
        
        [loginTextField, passwordTextField, logInButton,spinnerView].forEach { contentView.addSubview($0) }
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            loginTextField.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 120),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            spinnerView.centerXAnchor.constraint(equalTo: logInButton.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: logInButton.centerYAnchor),
        ])
    }
}
