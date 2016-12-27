//
//  ReusableView.swift
//  booth-ios-app
//
//  Created by SaitoKeisei on 2016/12/27.
//  Copyright © 2016 pixiv Inc. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}

extension UITableViewCell: ReusableView { }
