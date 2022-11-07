//
//  SettingsViewCell.swift
//  FileManager
//
//  Created by Fanil_Jr on 24.10.2022.
//

import Foundation
import UIKit

class SettingsViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Сортировка по алфавиту"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        return mySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialLayout()
        mySwitch.isOn = UserDefaults.standard.bool(forKey: "sorted")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Initial layout
    func initialLayout() {
        [label, mySwitch].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            mySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc func toggleSwitch() {
        UserDefaults.standard.setValue(mySwitch.isOn, forKey: "sorted")
    }

}
