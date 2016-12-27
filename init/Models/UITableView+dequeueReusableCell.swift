//
//  UITableView+dequeueReusableCell.swift
//  booth-ios-app
//
//  Created by SaitoKeisei on 2016/12/27.
//  Copyright © 2016 pixiv Inc. All rights reserved.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

}
