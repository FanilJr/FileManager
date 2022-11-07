//
//  TableViewCell.swift
//  FileManager
//
//  Created by Fanil_Jr on 24.10.2022.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    private lazy var myImage: UIImageView = {
        let myImage = UIImageView()
        myImage.translatesAutoresizingMaskIntoConstraints = false
        myImage.backgroundColor = .black
        myImage.clipsToBounds = true
        myImage.layer.cornerRadius = 14
        myImage.contentMode = .scaleAspectFill
        return myImage
    }()
    
    private lazy var myLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.numberOfLines = 0
        myLabel.textColor = .black
        return myLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configMyCell(images: MyImages) {
        self.myImage.image = images.image
        self.myLabel.text = images.imageName
    }
    
    //MARK: Initial layout
    func layout() {
        
        contentView.addSubview(myImage)
        contentView.addSubview(myLabel)
        
        NSLayoutConstraint.activate([
            myImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            myImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
            myImage.widthAnchor.constraint(equalTo: myImage.widthAnchor),
            myImage.heightAnchor.constraint(equalTo: myImage.widthAnchor),
            
            myLabel.leadingAnchor.constraint(equalTo: myImage.trailingAnchor, constant: 16),
            myLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            myLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
