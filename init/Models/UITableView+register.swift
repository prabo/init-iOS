//
//  UITableView+register.swift
//  booth-ios-app
//
//  Created by SaitoKeisei on 2016/12/27.
//  Copyright © 2016 pixiv Inc. All rights reserved.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

}
