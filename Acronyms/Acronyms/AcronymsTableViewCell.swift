//
//  AcronymsCellTableViewCell.swift
//  Acronyms
//
//  Created by Rahul Kamra on 20/07/22.
//

import UIKit

class AcronymsTableViewCell: UITableViewCell {
    
    lazy var acronymFullFormLabel: UILabel = {
       var label = UILabel()
       label.textColor = .black
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.systemFont(ofSize: 15)
       label.numberOfLines = 0
      return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(acronymFullFormLabel)
            
            NSLayoutConstraint.activate([
                acronymFullFormLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                acronymFullFormLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                acronymFullFormLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                acronymFullFormLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    func setData(_ text: String) {
        self.acronymFullFormLabel.text = text
    }
    
}
