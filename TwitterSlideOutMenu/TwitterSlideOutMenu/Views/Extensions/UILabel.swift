//
//  UILabel.swift
//  TwitterSlideOutMenu
//
//  Created by Максим Шаптала on 30.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String) {
        self.init(frame: CGRect.zero)
        self.text = text
    }
}

