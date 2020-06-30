//
//  MenuHeaderView.swift
//  TwitterSlideOutMenu
//
//  Created by Максим Шаптала on 30.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

final class MenuHeaderView: UIView {
    
    class AttributedLabel: UILabel {
        
        var boldText: String {
            didSet {
                boldString.mutableString.setString(boldText)
            }
        }
        var regularText: String {
            didSet {
                regularString.mutableString.setString(regularText)
            }
        }
        
        fileprivate let attributedString = NSMutableAttributedString()
        fileprivate var boldString: NSMutableAttributedString
        fileprivate var regularString: NSMutableAttributedString
        
        init(boldText: String, regularText: String) {
            self.boldText = boldText
            self.regularText = regularText
            
            self.boldString = NSMutableAttributedString(string: boldText, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
            self.regularString = NSMutableAttributedString(string: regularText, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
            
            super.init(frame: CGRect.zero)
            
            attributedString.append(boldString)
            attributedString.append(NSAttributedString(string: " "))
            attributedString.append(regularString)
            
            attributedText = attributedString
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel(text: "Max Shaptala")
    let usernameLabel = UILabel(text: "@maxshaptala")
    let followingLabel = AttributedLabel(boldText: "72", regularText: "following")
    let followersLabel = AttributedLabel(boldText: "120", regularText: "followers")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let horStackView = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        horStackView.axis = .horizontal
        horStackView.distribution = .fill
        horStackView.spacing = 10
        
        followingLabel.setContentHuggingPriority(UILayoutPriority(2), for: .horizontal)
        followingLabel.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
        
        followersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        followersLabel.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
        
        let overallStackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel, usernameLabel, horStackView])
        overallStackView.axis = .vertical
        overallStackView.distribution = .fill
        overallStackView.alignment = .leading
        overallStackView.spacing = 5
        overallStackView.setCustomSpacing(15, after: usernameLabel)
        
        addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        overallStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.layer.shadowColor = UIColor.gray.cgColor
        profileImageView.layer.shadowColor = UIColor.gray.cgColor
        profileImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileImageView.layer.shadowRadius = 2.5
        profileImageView.layer.shadowOpacity = 1
        let image = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal)
        profileImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
