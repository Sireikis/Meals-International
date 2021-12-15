//
//  CategoriesFooterView.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/15/21.
//

import Foundation
import UIKit


class CategoriesFooterView: UITableViewHeaderFooterView {
    
    let label = UILabel(frame: .zero)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureFooter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    private func configureFooter() {
        let sectionFooterLabelView = UIView(frame: .zero)
        sectionFooterLabelView.translatesAutoresizingMaskIntoConstraints = false
        sectionFooterLabelView.backgroundColor = .white

        contentView.addSubview(sectionFooterLabelView)
        sectionFooterLabelView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.italicSystemFont(ofSize: 12)
 
        
        
        //sectionFooterLabelView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: sectionFooterLabelView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: sectionFooterLabelView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: sectionFooterLabelView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: sectionFooterLabelView.trailingAnchor),
            
//            sectionFooterLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            sectionFooterLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            sectionFooterLabelView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            sectionFooterLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
//        let topAnchor = label.topAnchor.constraint(equalTo: sectionFooterLabelView.topAnchor, constant: 10)
//        let botAnchor = label.bottomAnchor.constraint(equalTo: sectionFooterLabelView.bottomAnchor)
//        let leadingAnchor = label.leadingAnchor.constraint(equalTo: sectionFooterLabelView.leadingAnchor, constant: 10)
//        let trailingAnchor = label.trailingAnchor.constraint(equalTo: sectionFooterLabelView.trailingAnchor)
//
//        topAnchor.isActive = true
//        botAnchor.isActive = true
//        leadingAnchor.isActive = true
//        trailingAnchor.isActive = true
    }
    
//    public func updateLabel(text: String) {
//        label.text = text
//    }
}
