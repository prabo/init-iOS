//
//  NibLoadableView.swift
//  booth-ios-app
//
//  Created by SaitoKeisei on 2016/12/27.
//  Copyright © 2016 pixiv Inc. All rights reserved.
//

import UIKit

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }

}

extension UITableViewCell: NibLoadableView { }
