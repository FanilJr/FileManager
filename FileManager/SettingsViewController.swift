//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Fanil_Jr on 24.10.2022.
//

import Foundation
import UIKit
import Locksmith

class SettingsViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.rowHeight = 70
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: Initial layout
    func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tapEditPassword() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            if loginVC.loginState == .signUp {
                loginVC.modalPresentationStyle = .automatic
                loginVC.loginState = .passEdit
                self.navigationController?.present(loginVC, animated: true)
                loginVC.loginState = .passEdit
                loginVC.button.setTitle("Изменить", for: .normal)
            } else {
                print("no")
            }
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Settings"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            tapEditPassword()
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsViewCell else { return UITableViewCell()}
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var label: UIListContentConfiguration = cell.defaultContentConfiguration()
            label.text = "Изменить пароль"
            cell.contentConfiguration = label
            return cell
        }
        return UITableViewCell()
    }
    
    
}
