//
//  MenuItemCell.swift
//  TwitterSlideOutMenu
//
//  Created by Максим Шаптала on 30.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

final class MenuItemCell: UITableViewCell {
    var item: CellItem? {
        didSet {
            iconImageView.image = item?.icon?.withRenderingMode(.alwaysOriginal)
            titleLabel.text = item?.title
        }
    }
    
    fileprivate let iconImageView = IconImageView()
    fileprivate let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        let horStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        horStackView.axis = .horizontal
        horStackView.distribution = .fill
        horStackView.alignment = .fill
        horStackView.spacing = 16
        
        addSubview(horStackView)
        horStackView.translatesAutoresizingMaskIntoConstraints = false
        horStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        horStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        horStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        horStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horStackView.isLayoutMarginsRelativeArrangement = true
        horStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        iconImageView.setContentHuggingPriority(UILayoutPriority(2), for: .horizontal)
        iconImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class IconImageView: UIImageView {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 30, height: 30)
        }
    }
}
