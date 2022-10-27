//
//  ExplanatoryCell.swift
//  Icarus SMS
//
//  Created by Nikola Čubelić on 23.10.2021..
//  Copyright © 2021 Inxelo Technologies. All rights reserved.
//

import UIKit

class ExplanatoryCell: UITableViewCell {
    
    private let firstLabel = configure(UILabel()) {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        $0.font = .jostRegular(ofSize: 14)
    }
    
    private let secondLabel = configure(UILabel()) {
        $0.numberOfLines = 0
        $0.font = .jostRegular(ofSize: 14)
    }
    
    private let thirdLabel = configure(UILabel()) {
        $0.numberOfLines = 1
        $0.font = .jostRegular(ofSize: 14)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setup(text1: String, text2: String, text3: String) {
        firstLabel.text = text1
        secondLabel.text = text2
        thirdLabel.text = text3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondLabel)
        contentView.addSubview(thirdLabel)
        
        firstLabel.layout(using: [
            firstLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
        ])
        
        secondLabel.layout(using: [
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 10),
            secondLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            secondLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            secondLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        thirdLabel.layout(using: [
            thirdLabel.centerYAnchor.constraint(equalTo: firstLabel.centerYAnchor),
            thirdLabel.widthAnchor.constraint(equalToConstant: 20),
            thirdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
}
