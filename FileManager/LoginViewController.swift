//
//  LoginViewController.swift
//  FileManager
//
//  Created by Fanil_Jr on 24.10.2022.
//
import UIKit
import Locksmith

class LoginViewController: UIViewController {
    
    enum LoginState {
        case signUp
        case signIn
        case passEdit
    }
    var loginState = LoginState.signUp
    private var newPass: String = ""
    var isChange = false
    
    lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height: 100))
        passwordTextField.rightView = UIView(frame:CGRect(x:0, y:0, width:10, height: 100))
        passwordTextField.rightViewMode = .always
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 14
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.textColor = .black
        passwordTextField.delegate = self
        passwordTextField.minimumFontSize = 27
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        passwordTextField.layer.borderColor = CGColor(gray: 0, alpha: 1)
        passwordTextField.placeholder = "Введите пароль"
        passwordTextField.autocapitalizationType = .none
        return passwordTextField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
//        button.isHidden = true//кнопка скрыта и не активна, если пароль меньше 4х символов
        button.isEnabled = false
        button.addTarget(self, action: #selector(enterButton), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        stateButton()
        if (Locksmith.loadDataForUserAccount(userAccount: "FanilAccaunt12") != nil) {
            loginState = .signIn
        } else {
            loginState = .signUp
        }
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "FanilAccaunt12")
        print(dictionary ?? "No acc")
        passwordTextField.delegate = self
        stateButton()
        layout()
        if button.titleLabel?.text == "Изменить" {
            
            if newPass == "" {
                newPass = passwordTextField.text!
//                print(newPass)
//                passwordTextField.text = ""
                if passwordTextField.text! == newPass {
                    do {
                        try Locksmith.updateData(data: ["pass" : passwordTextField.text!], forUserAccount: "FanilAccaunt12")
//                        newPass = passwordTextField.text!
//                        self.navigationController?.setViewControllers([ListViewController()], animated: true)
                    } catch {
                        print("error")
                    }
                } else {
                    print("nihua")
                }
            }
        }
        
        view.backgroundColor = .lightGray
        
    }
    
    //MARK: - Если пользователь есть то входит в приложение
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !isChange else { return }
        if (Locksmith.loadDataForUserAccount(userAccount: "FanilAccaunt12") != nil) {
            loginState = .signIn
        } else {
            loginState = .signUp
        }
        isChange = true
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func layout() {
        [button, passwordTextField].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: button.topAnchor,constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    
    
    
    @objc func enterButton() {
        
        switch loginState {
            
        case .signUp:
            if newPass == "" {
                newPass = passwordTextField.text!
                passwordTextField.text = ""
                button.setTitle("Повторите пароль", for: .normal)
            } else {
                if passwordTextField.text! == newPass {
                    do {
                        try Locksmith.saveData(data: ["pass" : passwordTextField.text!], forUserAccount: "FanilAccaunt12")
                        newPass = ""
                        self.navigationController?.setViewControllers([ListViewController()], animated: true)
                    } catch {
                        print("error")
                    }
                } else {
                    let alertController = UIAlertController(title: "Внимание!", message: "Пароли не совпадают!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        case .signIn:
            guard let passwords = Locksmith.loadDataForUserAccount(userAccount: "FanilAccaunt12") else { return }
            //вызов нового usera
            if passwordTextField.text! == passwords["pass"] as? String {
                self.navigationController?.setViewControllers([ListViewController()], animated: true)
            } else {
                let alertController = UIAlertController(title: "Внимание!", message: "Неверный пароль!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        case .passEdit:
            button.setTitle("Изменить пароль", for: .normal)
            print("Изменить пароль")
        }
    }
    
    private func stateButton() {
        switch loginState {
        case .signUp:
            button.setTitle("Создать пароль", for: .normal)
        case .signIn:
            button.setTitle("Вход", for: .normal)
        case .passEdit:
            button.setTitle("Изменить пароль", for: .normal)
        }
    }
}

//MARK: - Extension
extension LoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (passwordTextField.text! as NSString).replacingCharacters(in: range, with: string)
        button.isEnabled = newString.count > 3
        return true
    }
}

